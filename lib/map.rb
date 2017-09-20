
require_relative "map_node"

class Map
  attr_accessor :polygon, :nodes

  def initialize(polygon)
    self.polygon = polygon
    self.nodes   = []
  end

  def base_angle
    360.0/polygon
  end

  def new_node(position, radius)
    nodes << MapNode.new(self, position, radius)
  end

  def collides?(position, radius)
    # loop over all nodes and return true if any are too near
    nodes.any do |node|
      node.distance(position) < node.radius + radius
    end
  end
end
