
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

  def search(query_point, query_radius)

    # TODO going to have to do this for each sub-space too, cause a node might belong in multiple lists

    query = [query_point] + [
      query_point + [query_radius, 0],
      query_point - [query_radius, 0],
      query_point + [0, query_radius],
      query_point - [0, query_radius]
    ]

    results = search_recursive(query_point, partition)
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
      dist = (node.send(dimension) - midpoint.send(dimension)).abs
      if dist < node.radius
        a << node
        b << node
      elsif node.send(dimension) < midpoint.send(dimension)
        a << node
      else
        b << node
      end
    end

    CollisionList.new(
      [
        partition_binary(a, !vertical),
        partition_binary(b, !vertical)
      ],
      midpoint,
      dimension
    )
  end
end
