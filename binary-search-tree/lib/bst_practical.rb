def kth_largest(tree_node, k)
  kth_node = { count: 0, correct_node: nil }
  reverse_inorder(tree_node, kth_node, k)[:correct_node]
end

def reverse_inorder(tree_node, kth_node, k)
  if tree_node && kth_node[:count] < k
    kth_node = reverse_inorder(tree_node.right, kth_node, k)
    if kth_node[:count] < k
      kth_node[:count] += 1
      kth_node[:correct_node] = tree_node
    end

    if kth_node[:count] < k
      kth_node = reverse_inorder(tree_node.left, kth_node, k)
    end
  end

  kth_node
end

def lca(tree_node, node1, node2)
  smaller = node1.value < node2.value ? node1.value : node2.value
  bigger = node1.value > node2.value ? node1.value : node2.value

  if tree_node.value >= smaller && tree_node.value <= bigger
    lca = tree_node
  elsif tree_node.value > smaller && tree_node.value > bigger
    lca = lca(tree_node.left, node1, node2)
  elsif tree_node.value < smaller && tree_node.value < bigger
    lca = lca(tree_node.right, node1, node2)
  end

  lca
end