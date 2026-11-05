class CreateLegalAcceptances < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :accepted_terms_at, :datetime

    create_table :legal_acceptances, id: :uuid do |t|
      t.references :user, null: false
      t.datetime :accepted_at, null: false
      t.string :document_revision, null: false
      t.string :terms_version, null: false
      t.string :privacy_version, null: false
      t.jsonb :document_snapshot, null: false
      t.timestamps
    end
    add_index :legal_acceptances, [ :user_id, :document_revision ], unique: true
  end
end
