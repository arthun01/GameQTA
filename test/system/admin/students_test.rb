require "application_system_test_case"

class Admin::StudentsTest < ApplicationSystemTestCase
  setup do
    @admin = admins(:one)
    @student = users(:student_one)

    # Login as admin
    visit new_admin_session_path
    fill_in "email_address", with: @admin.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_text "Dashboard"
  end

  test "visiting the dashboard" do
    visit admin_root_path
    assert_selector "h1", text: "Dashboard"
    assert_text "Total de Estudantes"
    assert_text "Média Global de Acertos"
  end

  test "blocking and unblocking a student" do
    visit admin_students_path

    within "#user_#{@student.id}" do
      assert_text "Ativo"
      click_button "Bloquear"
    end

    within "#user_#{@student.id}" do
      assert_text "Bloqueado"
      assert_button "Desbloquear"
      click_button "Desbloquear"
    end

    within "#user_#{@student.id}" do
      assert_text "Ativo"
      assert_button "Bloquear"
    end
  end
end
