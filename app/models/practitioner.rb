# == Schema Information
#
# Table name: practitioners
#
#  id                               :bigint           not null, primary key
#  approximate_birthdate            :boolean          default(FALSE)
#  approximate_deathdate            :boolean          default(FALSE)
#  birthdate                        :date
#  controversial                    :boolean          default(FALSE)
#  country_code(ISO 3166-1 alpha-2) :string
#  deathdate                        :date
#  legendary                        :boolean          default(FALSE)
#  name                             :string           not null
#  public_figure                    :boolean          default(FALSE)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  added_by_id                      :bigint
#  created_style_id                 :bigint
#  user_id                          :bigint
#
# Indexes
#
#  index_practitioners_on_added_by_id       (added_by_id)
#  index_practitioners_on_created_style_id  (created_style_id)
#  index_practitioners_on_deathdate         (deathdate)
#  index_practitioners_on_name              (name)
#  index_practitioners_on_public_figure     (public_figure)
#  index_practitioners_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (added_by_id => users.id)
#  fk_rails_...  (created_style_id => styles.id)
#  fk_rails_...  (user_id => users.id)
#
class Practitioner < ApplicationRecord
  prepend MemoWise

  belongs_to :user, optional: true
  belongs_to :added_by, class_name: "User"
  belongs_to :created_style, class_name: "Style", optional: true
  has_many :relationships
  has_many :disciple_relationships, -> { where(relation_type: "disciple") }, class_name: "Relationship", foreign_key: :other_practitioner_id
  has_many :master_relationships, -> { where(relation_type: "disciple") }, class_name: "Relationship", foreign_key: :practitioner_id
  has_many :disciples, class_name: "Practitioner", through: :disciple_relationships, source: :practitioner
  has_many :masters, class_name: "Practitioner", through: :master_relationships, source: :other_practitioner
  has_many :styles_learned, -> { distinct }, class_name: "Style", through: :master_relationships, source: :style
  has_many :styles_taught, -> { distinct }, class_name: "Style", through: :disciple_relationships, source: :style

  validates :name, presence: true

  def self.where_name_is_like(name, max_distance: 2)
    where(
      "LOWER(name) LIKE :like OR levenshtein(LOWER(name), :name) <= :max_distance",
      like: "#{name.downcase}%",
      name: name.downcase,
      max_distance: max_distance,
    )
  end

  def disciple_of!(other_practitioner, **options)
    self.relationships.create!(options.merge({ relation_type: "disciple", other_practitioner: other_practitioner }))
  end

  def disciple_of?(other_practitioner)
    masters.include?(other_practitioner)
  end
  memo_wise :disciple_of?

  def master_of!(other_practitioner, **options)
    other_practitioner.disciple_of!(self, **options)
  end

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

  def styles
    styles_learned.presence || styles_taught
  end

  def homonymous_practitioners(max_distance = 2)
    Practitioner
      .where(
        "levenshtein(LOWER(name), :name) <= :max_distance",
        name: name.downcase,
        max_distance:,
      )
      .where.not(id: id)
  end
  memo_wise :homonymous_practitioners
end
