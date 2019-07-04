class AddPlannedTimeToInvite < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :planned_time, :datetime

  end
end
