class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []
    @prc = prc || Proc.new { |x, y| x <=> y }
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[count-1] = @store[count-1], @store[0]
    popped_value = @store.pop
    BinaryMinHeap.heapify_down(store, 0, &prc)

    popped_value
  end

  def peek
    @store[0]
  end

  def push(val)
    @store << val
    BinaryMinHeap.heapify_up(store, count-1, &prc)
  end

  public
  def self.child_indices(len, parent_index)
    child_index_1 = parent_index*2 + 1
    child_index_2 = parent_index*2 + 2
    indices = []

    indices << child_index_1 if child_index_1 < len
    indices << child_index_2 if child_index_2 < len

    indices
  end

  def self.parent_index(child_index)
    raise 'root has no parent' if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |x, y| x <=> y }
    children_indices = child_indices(len, parent_idx)

    until children_indices.all? { |idx| prc.call(array[parent_idx], array[idx]) <= 0 }
      if children_indices.length == 2
        smaller_idx = prc.call(array[children_indices[0]], array[children_indices[1]]) == -1 ? children_indices[0] : children_indices[1]
      elsif children_indices.length == 1
        smaller_idx = children_indices[0]
      else
        return array
      end

      array[smaller_idx], array[parent_idx] = array[parent_idx], array[smaller_idx]
      parent_idx = smaller_idx
      children_indices = child_indices(len, parent_idx)
    end

    return array
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |x, y| x <=> y }
    return array if child_idx == 0
    parent_idx = parent_index(child_idx)
    child_val, parent_val = array[child_idx], array[parent_idx]

    if prc.call(child_val, parent_val) >= 0
      return array
    else
      array[child_idx], array[parent_idx] = parent_val, child_val
      heapify_up(array, parent_idx, len, &prc)
    end
  end
end
