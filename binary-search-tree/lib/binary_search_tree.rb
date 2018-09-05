# There are many ways to implement these methods, feel free to add arguments 
# to methods as you see fit, or to create helper methods.
require_relative 'bst_node'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    if @root.nil?
      @root = BSTNode.new(value)
    else
      BinarySearchTree.insert!(@root, value)
    end
  end

  def find(value, tree_node = @root)
    return nil if tree_node == nil || tree_node.value == nil
    return tree_node if value == tree_node.value

    if value > tree_node.value
      find(value, tree_node.right)
    else
      find(value, tree_node.left)
    end
  end

  def delete(value)
    @root = delete_node(@root, value)
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    return nil unless tree_node
    return tree_node unless tree_node.right
    maximum(tree_node.right)
  end

  def minimum(tree_node = @root)
    return nil unless tree_node
    return tree_node unless tree_node.left
    minimum(tree_node.left)
  end

  def depth(tree_node = @root)
    return -1 if tree_node.nil? || tree_node.value.nil?
    left_depth = 0
    right_depth = 0

    left_depth += 1 + depth(tree_node.left)
    right_depth += 1 + depth(tree_node.right)

    left_depth > right_depth ? left_depth : right_depth

    # left_depth = depth(tree_node.left)
    # right_depth = depth(tree_node.right)

    # [left_depth, right_depth].max + 1
  end 

  def is_balanced?(tree_node = @root)
    return true if tree_node.nil? || tree_node.value.nil?
    left = depth(tree_node.left)
    right = depth(tree_node.right)

    balanced = ((left-right).abs) <= 1
    return balanced && is_balanced?(tree_node.left) && is_balanced?(tree_node.right)
  end

  def in_order_traversal(tree_node = @root, arr = [])
    return [] if tree_node.nil?
    left_child = tree_node.left
    right_child = tree_node.right

    return [tree_node.value] if left_child.nil? && right_child.nil?
    in_order_traversal(left_child) + [tree_node.value] + in_order_traversal(right_child)
  end


  private
  # optional helper methods go here:
  def self.insert!(node, value)
    if node.nil?
      return BSTNode.new(value)
    elsif value > node.value
      node.right = insert!(node.right, value)
    elsif value <= node.value
      node.left = insert!(node.left, value)
    end

    node
  end


  def children_count(node)
    left_child = node.left
    right_child = node.right
    count = 0

    count += 1 if left_child
    count += 1 if right_child

    count
  end

  def delete_node(node, value)
    if node.value == value
      remove(node)
    elsif value > node.value
      node.right = delete_node(node.right, value)
    else
      node.left = delete_node(node.left, value)
    end
  end

  def remove(node)
    if children_count(node) == 0
      node = nil
    elsif children_count(node) == 1 && node.left
      node = node.left
    elsif children_count(node) == 1 && node.right
      node = node.right
    else
      node = replace_parent(node)
    end

    node
  end

  def replace_parent(node)
    new_parent = maximum(node.left)
    #promote_child(node.left, new_parent) if new_parent.left
    direct_child = promote_child(node.left) if new_parent.left

    new_parent.left = direct_child ? direct_child : node.left
    new_parent.right = node.right

    new_parent
  end

  # def promote_child(parent_node, child_node)
  #   until parent_node.nil? || parent_node.right == child_node
  #     parent_node = parent_node.right
  #   end

  #   parent_node.right = child_node.left
  # end

  def promote_child(node)
    if node.right
      parent = node
      child = node.right

      while child.right
        parent = parent.right
        child = child.right
      end

      parent.right = child.left
      nil
    else
      node.left
    end
  end
end

# test = BinarySearchTree.new
# test.insert(2)
# p test.root
# test.insert(4)
# p test.root