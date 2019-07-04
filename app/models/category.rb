class Category < ApplicationRecord
  has_many :tags, class_name: "tag", foreign_key: "reference_id"
end
