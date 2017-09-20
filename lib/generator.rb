
require_relative "map"
require "byebug"

class Generator
  attr_accessor :map, :node_size, :max_connections, :polygon

  extend Forwardable
  def_delegators :map, :nodes

  def initialize()
    self.node_size       = 1.0
    self.polygon         = 16
    self.max_connections = 4

    self.map = Map.new(polygon)
  end

  def run
    map.fill([0,0], node_size)

    (0..1).each do
      old_node, angle = frontier.sample

      node = map.new_node(old_node, angle, node_size)
    end

    nodes
  end

  def frontier
    f = []
    nodes.each do |node|
      f += potential_connections(node).map {|angle| [node, angle] }
    end
    f
  end

  def potential_connections(node)
    potentials = node.potential_connections
    return [] if node.connections.length >= max_connections

    potentials.reject do |angle|
      p = node.position + node_size + angle.to_vector * node_size

      map.collides? p, node_size
    end
  end
end
