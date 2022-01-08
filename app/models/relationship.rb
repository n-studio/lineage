# == Schema Information
#
# Table name: relationships
#
#  id                                             :bigint           not null, primary key
#  duration(in seconds)                           :integer
#  end_on                                         :date
#  relation_type(disciple/son/nephew/husband/...) :string           not null
#  start_on                                       :date
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  other_practitioner_id                          :bigint           not null
#  practitioner_id                                :bigint           not null
#  style_id                                       :bigint           not null
#
# Indexes
#
#  index_relationships_on_other_practitioner_id  (other_practitioner_id)
#  index_relationships_on_practitioner_id        (practitioner_id)
#  index_relationships_on_relation_type          (relation_type)
#  index_relationships_on_style_id               (style_id)
#
# Foreign Keys
#
#  fk_rails_...  (other_practitioner_id => practitioners.id)
#  fk_rails_...  (practitioner_id => practitioners.id)
#  fk_rails_...  (style_id => styles.id)
#
class Relationship < ApplicationRecord
  belongs_to :practitioner, optional: true
  belongs_to :other_practitioner, class_name: "Practitioner", optional: true
  belongs_to :style, counter_cache: :practitioners_count
end
