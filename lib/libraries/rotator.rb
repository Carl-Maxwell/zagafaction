
require_relative "numeric_monkeypatch"

class Rotator
  attr_accessor :angle

  extend Forwardable
  def_delegators :angle, :+, :-, :*, :/

  def initialize(angle)
    self.angle = angle
  end

  def to_vector
    Math.cos(radians)
  end

  def radians
    angle * Math::PI / 180.0
  end
end
