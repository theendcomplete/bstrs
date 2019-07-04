class Comment < ApplicationRecord
  belongs_to :tag, class_name: "tag", foreign_key: "tag_id"
end
