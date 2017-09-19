
class Map
  attr_accessor :max_connections, :polygon, :node_size, :nodes

  def initialize(polygon, max_connections)
    self.polygon         = polygon
    self.max_connections = max_connections
    self.node_size       = 1.0
    self.nodes           = []
  end

  def base_angle
    360.0/polygon
  end

  def new_node

  end

  # TODO this should take in [position, size], not [node, angle]
  # TODO need better abstraction. the idea of a global node_size is vernacular to the specific procedural design
    # TODO so each node should have a size, and it just happens they're always the same in this particular vernacular.
  def collides?(base_node, angle)
    potential_position = base_node.position + angle.to_vector*node_size

    # loop over all nodes and return true if any are too near
    nearest_node = nodes.any do |node|
      node.distance(potential_position) < node_size
    end
  end
end
