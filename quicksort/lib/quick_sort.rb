class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    return array if array.length <= 1

    pivot_idx = rand(array.length)
    left = []
    right = []

    array.each_with_index do |el, idx|
      next if idx == pivot_idx
      right << el if el >= array[pivot_idx]
      left << el if el < array[pivot_idx]
    end

    sort1(left) + [array[pivot_idx]] + sort1(right)
  end

  # In-place.
  def self.sort2!(array, start = 0, length = array.length, &prc)
    return array if length <= 1
    prc ||= Proc.new { |x, y| x <=> y }

    pivot_idx = partition(array, start, length, &prc)

    left_length = pivot_idx - start
    right_length = length - (left_length + 1)
    sort2!(array, start, left_length, &prc)
    sort2!(array, pivot_idx + 1, right_length, &prc)

    array
  end

  def self.mySort!(array, start = 0, length = array.length, &prc)
    return array if length <= 1
    prc ||= Proc.new { |x, y| x <=> y }
    pivot_idx = 0
    boundary = 1

    (start+1...length).each do |idx|
      if prc.call(array[idx], array[0]) == -1
        array[boundary], array[idx] = array[boundary], array[idx]
        boundary += 1
        pivot_idx += 1
      end
    end

    left_length = pivot_idx - start
    right_length = length - (left_length + 1)

    mySort!(array, start, left_length, &prc)
    mySort!(array, pivot_idx+1, right_length, &prc)

    array
  end

  def self.swap(array, a, b)
    array[a], array[b] = array[b], array[a]
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new { |x, y| x <=> y }

    pivot_idx = start
    pivot = array[start]

    ((start + 1)...(start + length)).each do |idx|
      if prc.call(pivot, array[idx]) > 0
        array[idx], array[pivot_idx + 1] = array[pivot_idx + 1], array[idx]
        pivot_idx += 1
      end
    end
    array[start], array[pivot_idx] = array[pivot_idx], array[start]

    pivot_idx
  end
end

# sort1 test
a = [10, 5, 1, 4, 2, 6 ,8]
b = [10, 5, 1, 4, 2, 6 ,8]
p a
p QuickSort.sort1(a)
p b
p QuickSort.mySort!(b)
