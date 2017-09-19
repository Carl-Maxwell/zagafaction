
class Map
  attr_accessor :max_connections, :polygon

  def initialize(polygon, max_connections)
    self.polygon = polygon
    self.max_connections = max_connections
  end

  def base_angle
    360.0/polygon
  end
end
