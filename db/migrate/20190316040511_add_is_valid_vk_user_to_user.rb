class AddIsValidVkUserToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_valid_vk_user, :boolean, default: true, null: false
  end
end
