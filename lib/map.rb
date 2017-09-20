
require_relative "map_node"
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

  def new_node(position, radius)
    node = MapNode.new(self, position, radius)

    nodes << node

    node
  end

  def collides?(position, radius)
    # loop over all nodes and return true if any are too near
    nodes.any? do |node|
      node.distance(position) < node.radius + radius
    end
  end
end
