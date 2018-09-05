require_relative 'graph'
require 'byebug'
require 'set'

# Implementing topological sort using both Khan's and Tarian's algorithms

# Khan's Alogrithm
def topological_sort(vertices)
  vertex_counts = {}
  sorted = []
  queue = []
  
  vertices.each do |vertex|
    vertex_counts[vertex] = vertex.in_edges.length
    queue << vertex if vertex.in_edges.empty?
  end

  until queue.empty?
    current_vertex = queue.shift
    sorted << current_vertex

    current_vertex.out_edges.each do |edge|
      target_vertex = edge.to_vertex
      vertex_counts[target_vertex] -= 1
      
      queue << target_vertex if vertex_counts[target_vertex] == 0
    end
  end

  sorted.length == vertices.length ? sorted : []
end

#Tarjan's algorithm (without cycle catching)
def topological_sort(vertices)
  order = []
  explored = Set.new

  vertices.each do |vertex|
    dfs!(order, explored, vertex) unless explored.include?(vertex)
  end

  order
end

def dfs!(order, explored, vertex)
  explored.add(vertex)

  vertex.out_edges.each do |edge|
    to_vertex = edge.to_vertex
    dfs!(order, explored, to_vertex) unless explored.include?(vertex)
  end

  order.unshift(vertex)
end

#Tarjan's algorithm (with cycle catching)
def topological_sort(vertices)
  order = []
  explored = Set.new
  temp = Set.new
  cycle = false

  vertices.each do |vertex|
    cycle = dfs!(order, explored, vertex, cycle) unless explored.include?(vertex)
    return [] if cycle
  end

  order
end

def dfs!(order, explored, vertex, cycle)
  return true if temp.include?(vertex)
  
  vertex.out_edges.each do |edge|
    to_vertex = edge.to_vertex
    cycle = dfs!(order, explored, to_vertex, cycle) unless explored.include?(vertex)
    return true if cycle
  end
  
  explored.add(vertex)
  temp.delete(vertex)
  order.unshift(vertex)
  false
end