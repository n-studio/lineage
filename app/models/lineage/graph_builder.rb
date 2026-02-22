class Lineage::GraphBuilder
  def initialize(practitioner:, style:, mode: :root)
    @practitioner = practitioner
    @style = style
    @mode = mode
  end

  def call
    @nodes = {}
    @edges = []
    @visited = Set.new

    walk(@practitioner)

    {
      nodes: @nodes.values,
      edges: @edges,
      current_id: @practitioner.id,
      flipped: @mode == :leaves
    }
  end

  private

  def walk(practitioner)
    queue = [practitioner]

    while queue.any?
      current = queue.shift
      next if @visited.include?(current.id)
      @visited.add(current.id)

      @nodes[current.id] = {
        id: current.id.to_s,
        name: current.name,
        country_code: current.country_code
      }

      children_of(current).each do |child|
        @nodes[child.id] ||= {
          id: child.id.to_s,
          name: child.name,
          country_code: child.country_code
        }

        edge = build_edge(current, child)
        @edges << edge unless @edges.any? { |e| e[:source] == edge[:source] && e[:target] == edge[:target] }

        queue << child unless @visited.include?(child.id)
      end
    end
  end

  def build_edge(parent, child)
    if @mode == :leaves
      { source: child.id.to_s, target: parent.id.to_s }
    else
      { source: parent.id.to_s, target: child.id.to_s }
    end
  end

  def children_of(practitioner)
    return Practitioner.none if @style.nil?

    case @mode
    when :leaves
      practitioner.masters_for(style: @style)
    else
      practitioner.disciples_for(style: @style)
    end
  end
end
