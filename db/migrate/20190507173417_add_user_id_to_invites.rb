class AddUserIdToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :user_id, :integer
  end
end
