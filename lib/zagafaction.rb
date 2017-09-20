
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
    Rasem::SVGImage.new({width: 100, height: 100}, f) do

      # TODO find an offset that keeps everything on the render

      scale = 10.0

      nodes.each do |node|
        circle(node.x*scale, node.y*scale, scale/2)

        node.connections.each do |connection|
          other = connection.other
          line(node.x*scale, node.y*scale, other.x*scale, other.y*scale)
        end
      end

      # maze.render()

    end
  end
end
