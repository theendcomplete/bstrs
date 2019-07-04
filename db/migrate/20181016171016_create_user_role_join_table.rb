class CreateUserRoleJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :roles
  end
end
