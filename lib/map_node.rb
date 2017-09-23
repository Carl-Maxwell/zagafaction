
require_relative "map"
require_relative "connection"
require_relative "edge"

require "forwardable"

class MapNode
  attr_accessor :connections, :position, :radius, :map, :uniqid

  extend Forwardable
  def_delegators :position, :x, :y
  def_delegators :map, :polygon, :base_angle

  @@id_count = 0

  def initialize(map, position, radius, connection = nil)
    self.position = Vector.new(position)
    self.radius   = radius

    self.connections = []
    self.connections << connection if connection

    self.uniqid = (@@id_count += 1)

    self.map = map
  end

  def new_connection(angle, edge)
    return if connections.map(&:angle).include? angle
    co = Connection.new(self, angle, edge)

    connections << co

    edge.add_connection(co)
  end

  def potential_connections
    (0...polygon).to_a
      .map    {|angle| base_angle*angle }
      .reject {|angle| connections.map(&:angle).include? angle }
  end

  def distance(other)
    other = if other.respond_to?(:position) then other.position else other end
    position.distance(other)
  end

  # default inspect runs into recursive performance issue
  # TODO improve these a bit

  def to_s
    self.class
  end

  def inspect
    self.class
  end
end
