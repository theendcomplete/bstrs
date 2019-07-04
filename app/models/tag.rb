class Tag < ApplicationRecord
  belongs_to :category, class_name: "category", foreign_key: "category_id"
  has_many :comments, class_name: "comment", foreign_key: "reference_id"
end
