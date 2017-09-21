
require_relative "libraries/numeric_monkeypatch"
require_relative "generator"

require "rasem"

if $PROGRAM_NAME == __FILE__
  # maze = ARGV.shift

  # unless maze
    g = Generator.new
    nodes = g.run()

    filename = "mazes/maze" + Dir.glob("mazes/maze*").length.to_s.rjust(2, "0")

    # File.write(filename, g.display)

    # maze = filename
  # end

  # count angle frequencies &c
  angle_frequencies = (0...16).to_a.map { 0 }
  position_frequencies = []
  nodes.each do |node|
    position_frequencies << node.position.to_a.map(&:abs).reduce(&:+).round(5)
    node.connections.each do |connection|
      angle_frequencies[(connection.angle/22.5).angle.round] += 1
    end
  end

  # min_freq = angle_frequencies.min
  # print angle_frequencies.map {|freq| (freq*1.0)/min_freq }
  # puts

  print position_frequencies.sort
  puts

  # generate output

  File.open("test.svg", "w") do |f|
    w, h = [1600, 1600]

    Rasem::SVGImage.new({width: w, height: h}, f) do

      #
      # find offsets for centering
      #

      scale = 1.0

      top_left = Vector.new([0.0, 0.0])
      bottom_right = Vector.new([0.0, 0.0])

      x_sorted = nodes.sort {|a, b| a.x <=> b.x }
      y_sorted = nodes.sort {|a, b| a.y <=> b.y }

      top_left[0] = x_sorted.first.x
      top_left[1] = y_sorted.first.y

      bottom_right[0] = x_sorted.last.x
      bottom_right[1] = y_sorted.last.y

      scale *= [1400/(bottom_right - top_left).length, 1.0].max

      offset = Vector.new([0 - top_left.x, 0 - top_left.y])

      offset *= scale
      offset += [100, 100]

      offset[0] += ((w-200)-(bottom_right.x - top_left.x)*scale)/2

      # background color

      rect(0, 0, w, h, fill: "#FFEFCC", stroke: "#E8DBAE");

      nodes.each do |node|
        p1 = node.position * scale + offset

        circle(p1.x, p1.y, 2, fill: "#9E6BB2")

        node.connections.each do |connection|
          other = connection.other

          p2 = other.position * scale + offset

          line(p1.x, p1.y, p2.x, p2.y, stroke_width: 2, stroke: "#E9B3FF")
        end

        g.potential_connections_rejects(node).each do |angle|
          edge_length = g.edge_length
          p3 = node.position + angle.to_vector * edge_length
          p3 = p3 * scale + offset

          line(p1.x, p1.y, p3.x, p3.y, stroke: "#74B296")
        end

        text(p1.x, p1.y, :fill => "#3A2D40") { raw node.uniqid }
      end

      # maze.render()

    end
  end
end
