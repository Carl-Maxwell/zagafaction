
require_relative "libraries/vector"

class CollisionList
  attr_accessor :store, :midpoint, :dimension

  include Enumerable

  def initialize(store, midpoint = nil, dimension = nil)
    self.store     = store
    self.midpoint  = Vector.new(midpoint) if midpoint
    self.dimension = dimension if dimension
  end

  def x
    midpoint.x
  end

  def y
    midpoint.y
  end

  def has_sublist?
    store.any? {|element| element.is_a?(CollisionList) }
  end

  def closest(other)
    # objects can't collide with themselves
    substore = store.reject {|element| element.object_id == other.object_id }

    substore.map!.with_index {|element, i| [i, element.distance(other)] }

    i, dist = substore.min_by {|element| element[1] }

    store[i]
  end

  #
  # Array-like methods
  #

  def arrayify
    s = store.to_a
    s.map do |element|
      if element.is_a?(CollisionList) then element.arrayify else element end
    end
  end

  def flatify
    output = []

    store.to_a.map do |element|
      if element.is_a?(CollisionList)
        output += element.flatify
      else
        output << element
      end
    end

    output
  end

  def get_midpoints_and_dimensions
    return [] unless midpoint && dimension

    output = [[midpoint, dimension]]

    store.to_a.map do |element|
      if element.is_a?(CollisionList)
        output += element.get_midpoints_and_dimensions
      end
    end

    output
  end

  def to_a
    store.to_a
  end

  def to_s
    store.map do |element|
      if element.is_a?(CollisionList) then element.to_s else element.to_s end
    end
  end

  def each(&block)
    store.each(&block)

    self
  end

  def <<(a)
    store << a

    self
  end

  def [](d)
    store[d]
  end

  def []=(d, value)
    store[d] = value
  end

  def method_missing(sym, *args, &block)
    giveback = self.store.send(sym, *args, &block)

    if giveback.is_a? Array
      CollisionList.new(giveback, midpoint, dimension)
    else
      giveback
    end
  end
end
