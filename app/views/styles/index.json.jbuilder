json.data do
  json.array! @styles, partial: "styles/style", as: :style
end
json.pagy @pagy_metadata
