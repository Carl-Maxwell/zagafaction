
require_relative "map"
require "forwardable"

class MapNode
  attr_accessor :connections, :position, :map

  extend Forwardable
  def_delegators :position, :x, :y, :distance
  def_delegators :map, :max_connections, :polygon, :base_angle

  def initialize(map, start_position, connection = nil)
    self.position = start_position

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
    return [] if connections.length == max_connections

    potentials = (0...polygon).to_a
      .map    {|angle| angle*base_angle }
      .reject {|angle| connections.map(&:angle).include? angle }

    potentials.reject do |angle|
      map.collides? self, angle
    end
  end
end
