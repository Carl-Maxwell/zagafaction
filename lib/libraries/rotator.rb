
require_relative "numeric_monkeypatch"
require_relative "vector"

class Rotator
  attr_accessor :angle

  def initialize(angle)
    self.angle = angle.is_a?(Rotator) ? angle.angle : angle
  end

  def to_vector
    Vector.new([radians.cos, radians.sin])
  end

  def radians
    (angle * Math::PI / 180.0).round(5)
  end

  def flip
    a = angle-180
    a += 360 if angle < 0
    Rotator.new(a)
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
    return other.angle == angle if angle.is_a?(Rotator)
    angle == other
  end
end
