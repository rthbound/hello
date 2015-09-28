# This migration comes from hello (originally 1)
class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.references :user, index: true
      t.string :type

      # for EmailCredential
      t.string :email
      t.string   :email_token_digest
      t.datetime :email_token_digested_at
      t.datetime :email_confirmed_at

      # WIP: combine these fields if this PR is chosen

      # for PasswordCredential
      t.string :digest 
      t.string   :reset_token_digest
      t.datetime :reset_token_digested_at

      t.timestamps
    end
  end
end
