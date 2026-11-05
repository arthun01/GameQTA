require "test_helper"
require "timeout"

class CodeReviewConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  class ConcurrentEmailAdmin < Admin
    class_attribute :ready_queue, :continue_queue
    before_create do
      self.class.ready_queue << true
      self.class.continue_queue.pop
    end
  end

  test "cross deletions on separate connections leave one administrator" do
    originals = Admin.order(:id).to_a
    attributes = originals.map(&:attributes)
    assert_equal 2, originals.count

    results = concurrently do |index|
      originals[1 - index].remove_from_team(actor: originals[index])
    end

    assert_equal 1, Admin.count
    assert_equal 1, results.count { |result| result != false && result.present? }
  ensure
    Admin.upsert_all(attributes, unique_by: :id) if attributes
  end

  test "simultaneous starts return the same attempt without losing answers" do
    user = users(:student_two)
    theme = themes(:one)
    original_attempt_ids = user.theme_attempts.ids

    results = concurrently { User.find(user.id).start_theme(Theme.find(theme.id)).id }

    assert_equal 1, results.uniq.count
    assert_equal 1, user.theme_attempts.in_progress.where(theme: theme).count
    attempt = ThemeAttempt.find(results.first)
    answer = attempt.reveal_question(time_multiplier: 1)
    assert_equal answer.id, User.find(user.id).start_theme(theme).question_submissions.sole.id
  ensure
    if user && original_attempt_ids
      user.theme_attempts.where.not(id: original_attempt_ids).destroy_all
    end
  end

  test "concurrent duplicate emails become a validation error instead of an exception" do
    ready = Queue.new
    continue = Queue.new
    ConcurrentEmailAdmin.ready_queue = ready
    ConcurrentEmailAdmin.continue_queue = continue
    email = "concurrent-admin@example.com"
    records = 2.times.map { ConcurrentEmailAdmin.new(email_address: email, password: "password") }
    threads = records.map do |record|
      Thread.new { ActiveRecord::Base.connection_pool.with_connection { record.save_for_team } }
    end
    Timeout.timeout(10) { 2.times { ready.pop } }
    2.times { continue << true }
    results = Timeout.timeout(10) { threads.map(&:value) }

    assert_equal [ false, true ], results.sort_by { |result| result ? 1 : 0 }
    assert_equal 1, Admin.where(email_address: email).count
    assert records.any? { |record| record.errors.of_kind?(:email_address, :taken) }
    assert_equal 2, Admin.where.not(email_address: email).count
  ensure
    2.times { continue << true } if continue
    threads&.each { |thread| thread.join(2) }
    Admin.where(email_address: email).destroy_all if email
  end

  private
    def concurrently
      ready = Queue.new
      start = Queue.new
      threads = 2.times.map do |index|
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            ready << true
            start.pop
            yield index
          end
        end
      end
      Timeout.timeout(10) { 2.times { ready.pop } }
      2.times { start << true }
      Timeout.timeout(10) { threads.map(&:value) }
    ensure
      2.times { start << true } if start
      threads&.each { |thread| thread.join(2) }
    end
end
