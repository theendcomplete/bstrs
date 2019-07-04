class AddTypeToVcommunity < ActiveRecord::Migration[5.2]
  def change
    add_column :vcommunities, :community_type, :string, default: 'group'
  end
end
