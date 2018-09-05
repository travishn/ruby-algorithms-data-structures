require_relative "heap"

class Array
  def heap_sort!
    current_idx = 1
    prc = Proc.new { |x, y| y <=> x }
    while current_idx < length
      parent_idx = BinaryMinHeap.parent_index(current_idx)
      BinaryMinHeap.heapify_up(self, current_idx, &prc)

      current_idx += 1
    end

    (self.length-1).downto(0) do |idx|
      self[0], self[idx] = self[idx], self[0]
      BinaryMinHeap.heapify_down(self, 0, idx, &prc)
    end

    return self
  end
end

require_relative "heap"

#you have an array of arrays where the subarrays represent a companies data
# Each element in the subarray / data has a timestamp and is already ordered
# Compile all of the data and sort it

def five_hundred_files(arr_of_arrs)
  # We will need to store info about where the element came from,
  # so we need to pass a proc that will compare the first item (the value)
  # from an entry containing relevant information
  prc = Proc.new { |el1, el2| el1[0] <=> el2[0] }
  heap = BinaryMinHeap.new(&prc)
  result = []

  # Populate with first elements
  arr_of_arrs.length.times do |i|
    # Relevant info: [value, origin array number, origin index]
    heap.push([arr_of_arrs[i][0], i, 0])
  end

  # Extract the minimum element and use the meta-data to select the
  # next element to push onto the heap
  while  heap.count > 0
    min = heap.extract
    result << min[0]

    next_arr_i = min[1]
    next_idx = min[2] + 1
    next_el = arr_of_arrs[next_arr_i][next_idx]

    heap.push([next_el, next_arr_i, next_idx]) if next_el
  end
  result
end


arr_of_arrs = [[3,5,7], [0,6], [0,6,28]]

p five_hundred_files(arr_of_arrs)

require_relative 'heap'

def almost_sorted(arr, k)
  heap = BinaryMinHeap.new
  # If k = 2, the first output element must be
  # within the first 3 numbers, so we build a heap of 3
  (k + 1).times do
    heap.push(arr.shift)
  end

  # Accounts for when the array runs out but we still have
  # numbers in our heap
  while heap.count > 0
    print heap.extract
    heap.push(arr.shift) if arr[0]
  end
end