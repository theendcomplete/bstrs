class CreateRequestResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :request_responses do |t|
      t.string :url
      t.text :params
      t.text :response
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
