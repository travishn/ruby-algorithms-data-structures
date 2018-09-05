require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    @store[index] = val
  end

  # O(1)
  def pop
    raise 'index out of bounds' if length == 0
    pos = @length + @start_idx
    @store[pos] = nil

    @length -= 1
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    @store[pos] = val

    @length += 1
  end

  # O(1)
  def shift
    raise 'index out of bounds' if length == 0
    @store[start_idx] = nil
    @start_idx = (start_idx + 1) % capacity
    @length -= 1
  end

  # O(1) ammortized
  def unshift(val)
    resize! if length == capacity
    @start_idx = (start_idx - 1) % capacity
    @length += 1
    
    @store[start_idx] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise 'index out of bounds' if index >= length
  end

  def resize!
    new_store = StaticArray.new(capacity*2)
    (start_idx...length+start_idx).each do |idx|
      new_store[idx] = @store[idx]
    end

    @store = new_store
    @capacity = capacity*2
  end
end
