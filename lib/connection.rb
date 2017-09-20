
require "forwardable"

class Connection
  attr_accessor :node, :edge, :angle

  extend Forwardable
  def_delegators :edge, :forward_vector, :forward_rotator

  def initialize(node, angle, edge = nil)
    self.node  = node
    self.angle = angle
    self.edge  = edge if edge
  end
end
