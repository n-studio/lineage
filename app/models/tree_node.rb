class TreeNode
  include ActiveModel::API
  prepend MemoWise

  attr_accessor :json, :position, :id, :name, :parent_ids, :children_ids, :children_json

  def load(json:)
    self.position = json[:position]
    self.id = json[:id]
    self.name = json[:name]
    self.parent_ids = json[:parent_ids]
    self.children_ids = json[:children_ids]
    self.children_json = json[:children]
    self
  end
end
