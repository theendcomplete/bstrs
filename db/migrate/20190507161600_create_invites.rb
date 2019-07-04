class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.text :request_params
      t.datetime :sent_at
      t.integer :invited_id
      t.integer :group_id

      t.timestamps
    end
  end
end
