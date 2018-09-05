class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    sum = 0
    self.each_with_index do |el, idx|
      if el.is_a?(Fixnum)
        sum += (el * idx)
      elsif el.is_a?(String)
        sum += (el.length * idx)
      elsif el.is_a?(Array)
        sum += el.hash
      end
    end

    return sum.hash
  end
end

class String
  def hash
    sum = 0
    self.chars.each_with_index do |letter, idx|
      sum += (letter.ord * idx)
    end

    return sum.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    sum = 0
    self.keys.each do |el|
      sum += el.hash
    end

    return sum
  end
end
