
class Debug
  def self.elapsed(name)
    puts "Performing #{name}"
    t = Time.now

    yield

    elapsed = (Time.now - t).to_f
    puts "took #{elapsed} seconds"
  end
end
