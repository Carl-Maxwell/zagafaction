
require_relative "map"
require_relative "connection"
require_relative "edge"

require "forwardable"

class MapNode
  attr_accessor :connections, :position, :radius, :map

  extend Forwardable
  def_delegators :position, :x, :y, :distance
  def_delegators :map, :polygon, :base_angle

  def initialize(map, position, radius, connection = nil)
    self.position = Vector.new(position)
    self.radius   = radius

    self.connections = []
    self.connections << connection if connection

    self.map = map
  end

  def new_connection(angle, edge)
    return if connections.map(&:angle).include? angle
    c = Connection.new(self, angle)

    connections << c

    edge.add_connection(self)
  end

  def potential_connections
    (0...polygon).to_a
      .map    {|angle| base_angle*angle }
      .reject {|angle| connections.map(&:angle).include? angle }
  end
end
