

# snagged this from stack overflow.
# https://stackoverflow.com/questions/2844526/why-is-sqrt-not-a-method-on-numeric

class Numeric
  (Math.methods - Module.methods).each do |method|
    define_method method do |*args|
      Math.send method, self, *args
    end
  end
end
