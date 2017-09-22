require_relative "lib/generator"
require_relative "lib/collision_map"

#Random::srand(174244244925392674317086725143365111051)

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

  strify = Proc.new do |thing|
    strify_sub = Proc.new do |t|
      if t.is_a? Array
        t.map(&strify_sub)
      else
        t.position.x
      end
    end

    thing.map(&strify_sub)
  end

  print strify.call(collision_map.partition)
  puts
  # print collision_map.partition[1]
  puts

  puts
  puts "---"
  puts

end
