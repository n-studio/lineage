json.data do
  json.partial! "practitioners/practitioner", practitioner: @practitioner
  json.tree @tree.json
end
