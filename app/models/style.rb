# == Schema Information
#
# Table name: styles
#
#  id                  :bigint           not null, primary key
#  name                :string           not null
#  practitioners_count :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_styles_on_name  (name)
#
class Style < ApplicationRecord
  has_many :relationships, dependent: :restrict_with_exception

  def self.where_name_is_like(name, max_distance: 2)
    where(
      "LOWER(name) LIKE :like OR levenshtein(LOWER(name), :name) <= :max_distance",
      like: "#{name.downcase}%",
      name: name.downcase,
      max_distance: max_distance,
    )
  end
end
