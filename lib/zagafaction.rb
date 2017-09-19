require_relative "map"

require "rasem"

if $PROGRAM_NAME == __FILE__
  maze = ARGV.shift

  unless maze
    m = Map.new(26,10)
    m.generate()

    filename = "mazes/maze" + Dir.glob("mazes/maze*").length.to_s.rjust(2, "0")

    File.write(filename, m.display)

    maze = filename
  end

  File.open("test.svg", "w") do |f|
    Rasem::SVGImage.new({width: 100, height: 100}, f) do
      # line(0, 0, 100, 100)

      # maze.render()

    end
  end
end
