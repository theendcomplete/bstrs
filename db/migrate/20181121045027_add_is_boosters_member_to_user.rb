class AddIsBoostersMemberToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :isBoostersMember, :boolean, default: false
  end
end
