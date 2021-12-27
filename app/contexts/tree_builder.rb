# [
#   {
#     position: [0],
#     id: 1,
#     name: "Grand master",
#     parent_ids: [],
#     children_ids: [2, 3],
#     children: [
#       {
#         position: [0, 0],
#         id: 2,
#         name: "Master #1",
#         parent_ids: [1],
#         children_ids: [4, 5],
#         children: [
#           { position: [0, 0, 0], id: 4, name: "Student #1", parent_ids: [2, 3], children_ids: [] },
#           { position: [0, 0, 1], id: 5, name: "Student #2", parent_ids: [2], children_ids: [] },
#         ]
#       },
#       {
#         position: [0, 1],
#         id: 3,
#         name: "Master #2",
#         parent_ids: [1],
#         children_ids: [5, 6],
#         children: [
#           { position: [0, 1, 0], id: 5, name: "Student #2", parent_ids: [2, 3], children_ids: [] },
#           { position: [0, 1, 1], id: 6, name: "Student #3", parent_ids: [3], children_ids: [] },
#         ]
#       },
#     ],
#   },
# ]

class TreeBuilder
  def initialize(practitioners: nil, mode: :root, style:)
    @practitioners = practitioners
    @mode = mode
    @style = style
  end

  def call
    @practitioner_ids = []
    @practitioner_positions = []
    @json = []

    Tree.new(json: fill_tree(@practitioners), flipped: @mode == :leaves)
  end

  private

  def fill_tree(practitioners, position: [])
    practitioners.each_with_index.map do |practitioner, index|
      node = {
        position: position + [index],
        id: practitioner.id,
        name: practitioner.name,
        parent_ids: parents_of(practitioner).pluck(:id),
        children_ids: children_of(practitioner).pluck(:id),
        children: should_show_children?(practitioner) ? fill_tree(children_of(practitioner), position: position + [index]) : [],
        loop: should_loop?(practitioner),
      }
      next if duplicate_on_same_level?(practitioner, position: position + [index])
      unless @practitioner_ids.include?(practitioner.id)
        @practitioner_ids << practitioner.id
        @practitioner_positions << position + [index]
      end
      node
    end.compact
  end

  def duplicate_on_same_level?(practitioner, position:)
    index = @practitioner_ids.index(practitioner.id)
    return false if index.nil?

    @practitioner_positions[index].size == position.size
  end

  def should_show_children?(practitioner)
    duplicate = @practitioner_ids.include?(practitioner.id)
    !duplicate
  end

  def should_loop?(practitioner)
    (children_of(practitioner).map(&:id) & @practitioner_ids).present?
  end

  def parents_of(practitioner)
    case @mode
    when :leaves
      practitioner.disciples_for(style: @style)
    else
      practitioner.masters_for(style: @style)
    end
  end

  def children_of(practitioner)
    case @mode
    when :leaves
      practitioner.masters_for(style: @style)
    else
      practitioner.disciples_for(style: @style)
    end
  end
end
