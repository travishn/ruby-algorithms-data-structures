class Node
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    @prev.next = @next
    @next.prev = @prev
    # optional but useful, connects previous node to next node
    # and removes self from list.
  end
end

class LinkedList
  include Enumerable
  def initialize
    @head = Node.new
    @tail = Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |node, j| return node if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next == @tail && @tail.prev == @head
  end

  def get(key)
    current_node = @head
    until current_node == @tail
      if current_node.key == key
        return current_node.val
      end

      current_node = current_node.next
    end

    return nil
  end

  def include?(key)
    self.each do |node|
      return true if node.key == key
    end

    return false
  end

  def append(key, val)
    new_node = Node.new(key, val)
    new_node.next = @tail
    new_node.prev = @tail.prev

    @tail.prev.next = new_node
    @tail.prev = new_node
  end

  def update(key, val)
    current_node = @head
    until current_node == @tail
      if current_node.key == key
        current_node.val = val
        break
      end

      current_node = current_node.next
    end
  end

  def remove(key)
    current_node = @head
    until current_node == @tail
      if current_node.key == key
        current_node.remove
        break
      end

      current_node = current_node.next
    end
  end

  def each(&block)
    current_head = @head.next
    until current_head == @tail
      block.call(current_head)
      current_head = current_head.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, node| acc << "[#{node.key}, #{node.val}]" }.join(", ")
  end
end
