json.data do
  json.array! @practitioners, partial: "practitioners/practitioner", as: :practitioner
end
json.pagy @pagy_metadata
