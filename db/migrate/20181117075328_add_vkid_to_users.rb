class AddVkidToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :vkid, :integer, default: nil
  end
end
