
require_relative "map"
require "forwardable"

class MapNode
  attr_accessor :connections, :position, :radius, :map

  extend Forwardable
  def_delegators :position, :x, :y, :distance
  def_delegators :map, :polygon, :base_angle

  def initialize(map, position, radius, connection = nil)
    self.position = position
    self.radius   = radius

    self.connections = []
    self.connections << connection if connection

    self.map = map
  end

  def new_connection(angle)
    return if connections.map(&:angle).include? angle
    c = Connection.new(self, angle)

    # TODO create edge?
  end

  def potential_connections
    (0...polygon).to_a
      .map    {|angle| angle*base_angle }
      .reject {|angle| connections.map(&:angle).include? angle }
  end
end
