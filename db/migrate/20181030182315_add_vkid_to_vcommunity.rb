# frozen_string_literal: true

class AddVkidToVcommunity < ActiveRecord::Migration[5.2]
  def change
    add_column :vcommunities, :vkid, :integer, default: 0
  end
end
