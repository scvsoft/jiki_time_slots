class CreateMonkeyCredentials < ActiveRecord::Migration
  def change
    create_table :monkey_credentials do |t|
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
