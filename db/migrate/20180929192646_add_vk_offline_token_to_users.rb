class AddVkOfflineTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :vk_offline_token, :string, :default => 0

  end
end
