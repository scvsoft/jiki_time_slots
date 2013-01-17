class AddRefreshTokenToMonkeyCredential < ActiveRecord::Migration
  def change
    add_column :monkey_credentials, :refresh_token, :string
  end
end
