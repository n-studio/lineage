# TODO: This implementation is messy and doesn't really make sense
# A complete rewrite is necessary

class Tree
  include ActiveModel::API
  prepend MemoWise

  attr_accessor :json, :flipped

  def flipped?
    flipped == true
  end

  def dig(*args)
    path = args.map { |a| [a, :children] }.flatten
    path.pop # remove last :children
    json.dig(*path)
  end

  def node_lowest_position(node)
    json
    json.select_if { |node| node }
  end

  # add a skip if:
  # - self appears somewhere else lower in the graph
  def li_class(node)
    level = node_appears_lower_level(node, [node[:id]])
    classes = []
    classes << "skip" if level > 0
    classes << "skip-level-#{level}" if level > 1
    classes.join(" ")
  end
  memo_wise :li_class

  # add a loop if:
  # - a child appears somewhere else lower in the graph
  def li_ul_class(node)
    level = node_appears_lower_level(node, node[:children_ids])
    classes = []
    classes << "loop" if level > 0
    classes.join(" ")
  end
  memo_wise :li_ul_class

  def node_appears_lower_level(relative_node, target_ids)
    positions = []
    target_ids.each do |target_id|
      json.each do |current_node|
        positions += crawl_and_extract_position(positions, current_node, target_id, relative_node)
      end
    end

    lowest_position = positions.uniq.sort { |a, b| compare_positions(a, b) }.last
    return 0 if lowest_position.nil?

    lowest_position.size - relative_node[:position].size
  end
  memo_wise :node_appears_lower_level

  def crawl_and_extract_position(positions, current_node, target_id, relative_node)
    if current_node[:id] == target_id && nodes_in_different_branches?(current_node, relative_node)
      positions << current_node[:position]
    end
    current_node[:children].each do |child_node|
      positions += crawl_and_extract_position(positions, child_node, target_id, relative_node)
    end
    positions
  end
  memo_wise :crawl_and_extract_position

  def nodes_in_different_branches?(node_1, node_2)
    size_1 = node_1[:position].size
    size_2 = node_2[:position].size
    for i in 0...[size_1, size_2].min
      return true if node_1[:position][i] != node_2[:position][i]
    end
    false
  end

  def left_ul_size(node)
    position_size = node[:position].size
    left_sibling_position = node[:position].dup
    left_sibling_position[position_size - 1] -= 1
    left_sibling_node = dig(*left_sibling_position)

    leaves_width(left_sibling_node)
  end

  def leaves_width(root_node, current_width: 0)
    width = current_width
    root_node[:children].each do |child|
      width = leaves_width(child, current_width: width)
    end
    width + (root_node[:children].size.zero? ? 1 : 0)
  end

  private

  def compare_positions(position1, position2)
    return -1 if position1.size < position2.size
    return 1 if position1.size > position2.size

    position1.each_with_index do |el, index|
      next if el == position2[index]

      return el <=> position2[index]
    end
    0
  end
end
