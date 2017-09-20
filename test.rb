require_relative "lib/generator"

g = Generator.new

print g.run.map {|node, angle| [node.position.to_a  , angle.angle]} #.map { |node| node.connections.map(&:angle) }
puts
