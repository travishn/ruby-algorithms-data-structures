require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    resize! if @count == num_buckets
    self[key.hash] << key unless include?(key)
    @count += 1
  end

  def include?(key)
    self[key.hash].include?(key)
  end

  def remove(key)
    self[key.hash].delete_at(self[key.hash].index(key)) if include?(key)
    @count -= 1
  end

  private

  def [](num)
    @store[num % num_buckets]
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_capacity = num_buckets*2
    new_store = Array.new(new_capacity) { [] }

    @store.flatten.each do |num|
      new_store[num % new_capacity] << num
    end

    @store = new_store
  end
end
