
require_relative "libraries/vector"

# TODO look into the delegator class / method_missing, etc
# there is probably an easier / more concise way to implement an array-like class

class CollisionList
  attr_accessor :store, :midpoint

  include Enumerable
  extend Forwardable

  def_delegators :midpoint, :x, :y

  def initialize(store, midpoint)
    self.store    = store
    self.midpoint = Vector.new(midpoint)
  end

  #
  # Array-like methods
  #

  # def each(&block)
  #   store.each(&block)
  #
  #   self
  # end
  #
  # def <<(a)
  #   store << a
  #
  #   self
  # end

  def method_missing(sym, *args, &block)
    otherstore = self.store.send(sym, *args, &block)

    CollisionList.new(otherstore, midpoint)
  end
end
