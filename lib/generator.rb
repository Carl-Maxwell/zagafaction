
require_relative "map"
require "byebug"

class Generator
  attr_accessor :map, :node_size, :edge_length, :max_connections, :polygon

  extend Forwardable
  def_delegators :map, :nodes

  def initialize()
    self.node_size       = 1.0
    self.edge_length     = 0.0 + node_size * 2.0
    self.polygon         = 16
    self.max_connections = 4

    self.map = Map.new(polygon)
  end

  def run
    map.fill([0,0], node_size)

    (0..4).each do
      f = frontier
      next unless f.length > 0
      old_node, angle = f.last#f.sample

      node = map.new_node(old_node, angle, node_size)

      # refresh_frontier([old_node, node])
    end

    nodes
  end

  def frontier
    #@@frontier ||=
    generate_frontier
  end

  def generate_frontier(list = nil)
    f = []
    (list || nodes).each do |node|
      f += potential_connections(node).map {|angle| [node, angle] }
    end
    f
  end

  def refresh_frontier(list)
    stale_nodes = @@frontier.select do |f_node, angle|
      list.any? {|node| f_node.distance(node.position) < node_size*2}
    end

    @@frontier -= stale_nodes
    stale_nodes.map!(&:first)

    @@frontier += generate_frontier(list + stale_nodes)
  end

  def potential_connections_rejects(node)
    potentials = node.potential_connections
    return [] if node.connections.length >= max_connections

    puts "angle included" if node.uniqid == 1 && potentials.include?(45.0)

    potentials.select do |angle|
      p = node.position + angle.to_vector * edge_length

      map.collides? p, node_size
    end
  end

  def potential_connections(node)
    potentials = node.potential_connections.shuffle
    return [] if node.connections.length >= max_connections

    potentials.reject do |angle|
      p = node.position + angle.to_vector * edge_length

      map.collides? p, node_size
    end
  end
end
