class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.integer :vkid
      t.integer :owner_id
      t.string :question
      t.integer :votes
      t.integer :end_date
      t.integer :author_id

      t.timestamps
    end
  end
end
