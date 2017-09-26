
require_relative "map_node"
require_relative "collision_map"
require_relative "libraries/rotator"

class Map
  attr_accessor :polygon, :nodes

  def initialize(polygon)
    self.polygon = polygon
    self.nodes   = []
  end

  def base_angle
    Rotator.new(360.0/polygon)
  end

  def fill(position, radius)
    node = MapNode.new(self, position, radius)
    nodes << node

    node
  end

  def new_node(old_node, position, angle, radius)
    node = MapNode.new(self, position, radius)
    nodes << node

    edge = Edge.new()
    node.new_connection(angle.flip, edge)
    old_node.new_connection(angle, edge)

    break_collision_cache

    node
  end

  #
  # Collision Code
  #

  def break_collision_cache
    @collision_map = nil
  end

  def collision_map
    @collision_map ||= CollisionMap.new(nodes)
  end

  def collides?(position, radius)
    results = collision_map.search(position, radius)

    # primary = nodes.find {|node| node.uniqid == 25}
    # byebug if primary && primary.position == position

    sixty = nodes.find {|node| node.uniqid == 60 }
    is_primary = radius/2 > position.distance([-7.025893615469979, -4.04929212003046])
    primary = nodes.find {|node| node.uniqid == 93 }

    # byebug if sixty && is_primary

    # results.reject! {|other| other.position.object_id == position.object_id }

    # loop over results and return true if any are too near
    collision = results.any? do |node|
      # byebug if sixty && is_primary && node == sixty
      node.distance(position) < node.radius + radius
    end

    byebug if !collision && sixty && is_primary

    collision
  end
end
