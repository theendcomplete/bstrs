class AddExtraFieldsToVcommunity < ActiveRecord::Migration[5.2]
  def change
    add_column :vcommunities, :city, :string
    add_column :vcommunities, :country, :string
    add_column :vcommunities, :place, :string
    add_column :vcommunities, :description, :string
    add_column :vcommunities, :start_date, :string
    add_column :vcommunities, :finish_date, :string
    add_column :vcommunities, :status, :string
  end
end
