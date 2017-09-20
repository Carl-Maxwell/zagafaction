
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

  def adjacent()
    adj = []

    (-1..1).each do |x|
      (-1..1).each do |y|
        next unless [x,y].include? 0
        adj << (self + [x, y]).to_a #[self[0] + x, self[1] + y]
      end
    end

    adj
  end

  def to_rotator
    # TODO convert to rotator
  end

  def to_a
    store
  end

  #
  # operators
  #

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
    elsif value.is_a? Fixnum
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
