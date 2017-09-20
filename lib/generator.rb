
class Generator
  attr_accessor :node_size, :max_connections

  def initialize()
    self.node_size       = 1.0
    self.polygon         = 16
    self.max_connections = 4;
  end

  def run

  end

  def frontier

  end

  def potential_connections(node)
    potentials = node.potential_connections
    return [] if potentials.length => max_connections

    potentials.reject do |angle|
      map.collides? node.position, node.position + node_size + angle.to_vector*node_size
    end
  end
end
