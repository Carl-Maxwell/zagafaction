
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
    map.new_node([0,0], node_size)

    f = frontier.sample
    node = map.new_node(*f)

    old_node, angle = f

    edge = Edge.new()
    node.new_connection(angle.flip, edge)
    old_node.new_connection(angle, edge)

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
