
require_relative "map"
require "byebug"

class Generator
  attr_accessor :map, :node_size, :edge_length, :max_connections, :polygon, :space, :space_radius

  extend Forwardable
  def_delegators :map, :nodes

  def initialize(polygon, space = [2, 2])
    self.node_size       = 1.0
    self.edge_length     = 0.75 + node_size * 2.0
    self.polygon         = polygon || 16
    self.max_connections = 4
    self.space           = Vector.new(space)
    self.space_radius    = self.space.length/2.0

    self.map = Map.new(polygon)
  end

  def run
    map.fill([0,0], node_size)

    (0..100).each do
      f = frontier
      unless f.length > 0
        puts "space exhausted"
        break
      end
      old_node, angle = f.sample

      p = old_node.position + angle.to_vector * edge_length

      node = map.new_node(old_node, p, angle, node_size)

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

    potentials.select do |angle|
      p = node.position + angle.to_vector * edge_length

      map.collides? p, node_size
    end
  end

  def valid_position(pos)
    pos.length+node_size < space_radius
  end

  def potential_connections(node)
    potentials = node.potential_connections.shuffle
    return [] if node.connections.length >= max_connections

    potentials.reject do |angle|
      p = node.position + angle.to_vector * edge_length

      next true unless valid_position(p)

      map.collides? p, node_size
    end
  end
end
