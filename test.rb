require_relative "lib/generator"

g = Generator.new

print g.run#.map { |node| node.connections.map(&:angle) }
puts
