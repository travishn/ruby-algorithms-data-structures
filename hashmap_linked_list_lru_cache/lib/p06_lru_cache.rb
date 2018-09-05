require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      target_node = @map.get(key)
      update_node!(target_node)
      @map.set(key, target_node)
    else
      calc!(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    new_node = Node.new(key, @prc.call(key))
    @store.append(new_node.key, new_node.val)
    @map.set(key, new_node)

    eject! if count > @max
    # suggested helper method; insert an (un-cached) key
  end

  def update_node!(node)
    @store.remove(node.key)
    @store.append(node.key, node.val)
    # suggested helper method; move a node to the end of the list
  end

  def eject!
    oldest_node = @store.first
    oldest_node.remove
    @map.delete(oldest_node.key)
  end
end
