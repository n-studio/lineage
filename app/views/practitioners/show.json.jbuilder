json.data do
  json.partial! "practitioners/practitioner", practitioner: @practitioner
  json.graph @graph_data
end
