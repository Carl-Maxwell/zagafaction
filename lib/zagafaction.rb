
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

  File.open("test.svg", "w") do |f|
    Rasem::SVGImage.new({width: 1600, height: 1600}, f) do

      # TODO find an offset that keeps everything on the render

      scale = 1.0 # 10.0

      #
      # find offsets for centering
      #

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

      nodes.each do |node|
        p1 = node.position * scale + offset

        # circle(p1.x, p1.y, 20/scale)

        node.connections.each do |connection|
          other = connection.other

          p2 = other.position * scale + offset

          line(p1.x, p1.y, p2.x, p2.y)
        end
      end

      # maze.render()

    end
  end
end
