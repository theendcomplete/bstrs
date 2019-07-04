class AddTrackablegToUsers < ActiveRecord::Migration[5.2]
  def change
    # change_table :users do |t|
    ## Trackable
    add_column :users, :sign_in_count, :integer, :default => 0
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    ## t.add_column :current_sign_in_ip, :string
    ## t.add_column :last_sign_in_ip, :string
    # end
  end
end
