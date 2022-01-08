# == Schema Information
#
# Table name: alternative_names
#
#  id            :bigint           not null, primary key
#  language      :string
#  language_info :string
#  model_type    :string
#  name          :string
#  unusual       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  model_id      :bigint
#
# Indexes
#
#  index_alternative_names_on_model  (model_type,model_id)
#
class AlternativeName < ApplicationRecord
end
