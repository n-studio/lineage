class Relationship < ApplicationRecord
  belongs_to :practitioner, optional: true
  belongs_to :other_practitioner, class_name: "Practitioner", optional: true
  belongs_to :style, optional: true
end
