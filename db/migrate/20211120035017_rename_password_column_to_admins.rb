class RenamePasswordColumnToAdmins < ActiveRecord::Migration[5.2]
  def change
    rename_column :admins, :password, :encrypted_password
  end
end
