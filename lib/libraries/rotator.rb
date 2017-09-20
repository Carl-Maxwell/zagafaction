
require_relative "numeric_monkeypatch"

class Rotator
  attr_accessor :angle

  extend Forwardable
  def_delegators :angle, :+, :-, :*, :/

  def initialize(angle)
    self.angle = angle
  end

  def to_vector
    Vector.new([radians.cos, radians.sin])
  end

  def radians
    angle * Math::PI / 180.0
  end
end
