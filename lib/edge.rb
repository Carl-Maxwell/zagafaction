

class Edge
  attr_accessor :connections, :nodes

  def initialize(connection1, connection2 = nil)
    self.connections << connection1
    self.connections << connection2 if connection2
  end

  def nodes
    connections.map(&:node)
  end
end
