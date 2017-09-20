
require_relative "numeric_monkeypatch"

class Vector
  attr_accessor :store

  def initialize(values)
    @store = *values
  end

  def distance(other)
    (self - other).length
  end

  def length
      self.to_a.map {|x| x**2}.reduce(&:+).sqrt
  end

  def normalize
    self./(length)
  end

  def normalize!
    self.store = self.normalize.store
  end

  #
  # casting
  #

  def to_rotator
    n = normalize
    Rotator.new(Math.atan2(n.y, n.x) * 180.0/Math::PI)
  end

  def to_a
    store
  end

  #
  # operators
  #

  def x
    store[0]
  end

  def y
    store[1]
  end

  def [](x)
    store[x]
  end

  def []=(x, value)
    store[x] = value
  end

  def operation(op, value)
    if value.respond_to? :to_a
      value = value.to_a
      Vector.new( (store.map.with_index do |elem, i|
        op.to_proc.call(elem, value[i])
      end ) )
    elsif value.is_a?(Integer) || value.is_a?(Float)
      Vector.new( (store.map do |elem|
        op.to_proc.call(elem, value)
      end ) )
    else
      raise "#{value.class} is an invalid value type in Vector operation!"
    end
  end

  def +(value)
    operation(:+, value)
  end

  def -(value)
    operation(:-, value)
  end

  def *(value)
    operation(:*, value)
  end

  def /(value)
    operation(:/, value)
  end

  def ==(other)
    return other.to_a == store if other.respond_to?(:to_a)
    store == other.store
  end
end
