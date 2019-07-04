class ChangeUsersVkOfflineTokenDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :vk_offline_token, nil)
  end
end