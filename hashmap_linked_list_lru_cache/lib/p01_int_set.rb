class MaxIntSet
  attr_reader :max
  #insert => O(1)
  #remove => O(1)
  #include => O(1)
  #space complexity => O(range)

  #utilizes an array from min to max with each index pointing to either true or false

  def initialize(max)
    @max = max
    @store = Array.new(max) {false}
  end

  def insert(num)
    validate!(num)
    @store[num] = true
  end

  def remove(num)
    validate!(num)
    @store[num] = false
  end

  def include?(num)
    return @store[num]
  end

  private

  def is_valid?(num)
    num >= 0 && num < max
  end

  def validate!(num)
    raise 'Out of bounds' unless is_valid?(num)
  end
end


class IntSet
  #insert => O(n)
  #remove => O(n)
  #include => O(n)

  #utilizes an array of buckets and the modulo operator to determine which int gets placed into which bucket
  #back to where we started where its the same as just iterating through to find or remove a number in a normal array
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num] << num unless include?(num)
  end

  def remove(num)
    if include?(num)
      self[num].delete_at(self[num].index(num))
      # self[num].each_with_index do |bucket_num, idx|
      #   if bucket_num == num
      #     self[num][idx] = nil
      #     break
      #   end
      # end
    end
  end

  def include?(num)
    self[num].each do |bucket_num|
      return true if bucket_num == num
    end

    return false
  end

  private

  def [](num)
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  #insert => AC = O(1) || WC = O(n)
  #include => AC = O(1) || WC = O(n)
  #remove => AC = O(1) || WC = O(n)

  #Worst case is O(N) because what happens when you have an array of ints that are all multiples of 2?
  #They all end up in the first bucket and so your include method no longer has the average case of having 1 element per bucket
  #Instead it'll be O(n) which will cause insert and remove to be O(n) because for both methods, you need to use include
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if @store.length == @count
    self[num] << num unless include?(num)
    @count += 1
  end

  def remove(num)
    self[num].delete_at(self[num].index(num)) if include?(num)
  end

  def include?(num)
    self[num].each do |bucket_num|
      return true if num == bucket_num
    end

    return false
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
