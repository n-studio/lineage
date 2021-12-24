class Practitioner < ApplicationRecord
  has_many :relationships
  has_many :disciple_relationships, -> { where(relation_type: "disciple") }, class_name: "Relationship", foreign_key: :other_practitioner
  has_many :master_relationships, -> { where(relation_type: "disciple") }, class_name: "Relationship", foreign_key: :practitioner
  has_many :disciples, class_name: "Practitioner", through: :disciple_relationships, source: :practitioner
  has_many :masters, class_name: "Practitioner", through: :master_relationships, source: :other_practitioner

  def disciple_of!(other_practitioner, **options)
    self.relationships.create!(options.merge({ relation_type: "disciple", other_practitioner: other_practitioner }))
  end

  def disciple_of?(other_practitioner)
    masters.include?(other_practitioner)
  end

  def master_of?(other_practitioner)
    disciples.include?(other_practitioner)
  end

  def disciples_excluding(practitioners)
    disciples.to_a.delete_if { |disciple| practitioners.include?(disciple) }
  end
end
