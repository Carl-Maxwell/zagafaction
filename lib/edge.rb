

class Edge
  attr_accessor :connections, :nodes

  def initialize(connection1 = nil, connection2 = nil)
    self.connections = []
    self.connections << connection1 if connection1
    self.connections << connection2 if connection2
  end

  def nodes
    connections.map(&:node)
  end

  def add_connection(connection)
    connections << connection
  end
end
