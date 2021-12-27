class Practitioner < ApplicationRecord
  prepend MemoWise

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
  memo_wise :disciple_of?

  def master_of?(other_practitioner)
    disciples.include?(other_practitioner)
  end
  memo_wise :master_of?

  def disciples_for(style:, excluding: nil, includes: false)
    results = disciples.where("relationships.style_id": style.id)
    results = results.includes(includes) if includes
    results = results.to_a.delete_if { |disciple| excluding.include?(disciple) } if excluding.present?
    results
  end
  memo_wise :disciples_for

  def masters_for(style:, excluding: nil, includes: false)
    results = masters.where("relationships.style_id": style.id)
    results = results.includes(includes) if includes
    results = results.to_a.delete_if { |master| excluding.include?(master) } if excluding.present?
    results
  end
  memo_wise :masters_for
end
