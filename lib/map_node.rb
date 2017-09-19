
require_relative "./../map"
require "forwardable"

class MapNode
  attr_accessor :connections, :position, :map

  extend Forwardable
  def_delegators :position, :x, :y
  def_delegators :@map, :max_connections, :polygon, :base_angle

  def initialize(map, start_position, connection = nil)
    self.position = start_position

    self.connections = []
    self.connections << connection if connection

    self.map = map
  end

  def potential_connections
    return [] if connections.length == max_connections

    (0..polygon).to_a
      .map    {|angle| angle*base_angle }
      .reject {|angle| connections.map(&:angle).include? angle }
  end
end
