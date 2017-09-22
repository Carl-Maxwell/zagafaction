
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

  def partition_binary(nodes, vertical = true)
    return nodes if nodes.length <= 6

    midpoint = nodes.reduce(Vector.new([0, 0])) do |sum, node|
      sum + node.position
    end
    midpoint /= nodes.length

    a, b = CollisionList.new([], midpoint), CollisionList.new([], midpoint)

    # TODO there is actually a .partition function in Enumerable

    #a, b = nodes.partition {|node| node.position[dimension] < midpoint[dimension] }

    dimension = if vertical then :x else :y end

    nodes.each do |node|
      if node.position[dimension] < midpoint[dimension]
        a << node
      else
        b << node
      end
    end

    [partition_binary(a), partition_binary(b)]
  end
end
