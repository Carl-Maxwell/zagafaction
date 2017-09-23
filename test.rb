require_relative "lib/generator"
require_relative "lib/collision_map"

Random::srand(174244244925392674317086725143365111051)

(1..1).each do
  g = Generator.new(16, [20, 20])

  nodes = g.run

  nodes.each { |node| node.position.store.map! {|a| a.round(2)} }

  # print nodes.map(&:position)
  puts

  puts
  puts "---"
  puts

  collision_map = CollisionMap.new(nodes)

  # strify = Proc.new do |thing|
  #   strify_sub = Proc.new do |t|
  #     if t.is_a?(Array) || t.is_a?(CollisionList)
  #       t.map(&strify_sub)
  #     else
  #       t.x
  #     end
  #   end
  #
  #   thing.map(&strify_sub)
  # end

  # print strify.call(collision_map.partition)
  puts
  # print collision_map.partition[1]
  puts

  node = nodes.sample

  print node.position
  puts

  puts "Performing old exponential cost algorithm"
  t = Time.now

  collision = nodes.any? do |other|
    other.distance(node) < other.radius + node.radius
  end

  elapsed = (Time.now - t).to_f
  puts "took #{elapsed} seconds"

  puts "Performing BSP algorithm"
  t = Time.now

  results = collision_map.search(node.position)

  results.closest(node).position.to_a

  elapsed = (Time.now - t).to_f
  puts "took #{elapsed} seconds"

  print results.length
  puts

  print results.map {|r| r.is_a?(Array) ? r.map(&:class) : r.class }
  puts

  print "query node: \n"

  print node.position.to_a
  puts

  print "result nodes: \n"
  print results.map(&:position).map(&:to_a)
  puts

  print "closest result: \n"
  print results.closest(node).position.to_a
  puts


  puts
  puts "---"
  puts
end
