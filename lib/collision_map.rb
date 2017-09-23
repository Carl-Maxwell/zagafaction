
require_relative "libraries/numeric_monkeypatch"
require_relative "libraries/vector"
require_relative "libraries/rotator"
require_relative "collision_list"

class CollisionMap
  attr_accessor :nodes, :partition

  def initialize(nodes)
    self.nodes     = nodes
    self.partition = partition_binary(nodes)
  end

  def search(query)
    results = search_recursive(query, partition)

    # TODO find closest, exclude the query itself
  end

  def search_recursive(query, list)
    return list if !(list.is_a?(CollisionList) && list.has_sublist?)

    dimension = list.dimension

    # print "query: #{query.send(dimension)} < midpoint #{list.send(dimension)}\n"

    if query.send(dimension) < list.send(dimension)
      search_recursive(query, list[0])
    else
      search_recursive(query, list[1])
    end
  end

  def partition_binary(nodes, vertical = true)
    return CollisionList.new(nodes) if nodes.length <= 6

    midpoint = nodes.reduce(Vector.new([0, 0])) do |sum, node|
      sum + node.position
    end
    midpoint /= nodes.length

    a, b = [], []

    dimension = if vertical then :x else :y end

    nodes.each do |node|
      if node.send(dimension) < midpoint.send(dimension)
        a << node
      else
        b << node
      end
    end

    CollisionList.new([partition_binary(a), partition_binary(b)], midpoint, dimension)
  end
end
