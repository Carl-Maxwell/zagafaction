
require_relative "numeric_monkeypatch"
require_relative "vector"

class Rotator
  attr_accessor :angle

  # extend Forwardable
  # def_delegators :angle, :==, :-, :*, :/

  def initialize(angle)
    self.angle = angle.responds_to?(:angle) ? angle.angle : angle
  end

  def to_vector
    Vector.new([radians.cos, radians.sin])
  end

  def radians
    angle * Math::PI / 180.0
  end

  #
  #
  #

  def +(value)
    Rotator.new(angle + value)
  end

  def -(value)
    Rotator.new(angle - value)
  end

  def *(value)
    Rotator.new(angle * value)
  end

  def /(value)
    Rotator.new(angle / value)
  end

  def ==(other)
    return other.angle == angle if other.respond_to?(:angle)
    angle == other
  end
end
