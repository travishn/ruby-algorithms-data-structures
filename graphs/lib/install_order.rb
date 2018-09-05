# Given an Array of tuples, where tuple[0] represents a package id,
# and tuple[1] represents its dependency, determine the order in which
# the packages should be installed. Only packages that have dependencies
# will be listed, but all packages from 1..max_id exist.

# N.B. this is how `npm` works.

# Import any files you need to


require_relative 'graph'
require_relative 'topological_sort'


def install_order(arr)
  max = 0
  independent = []
  vertices = {}

  arr.each do |tuple|
    vertices[tuple[0]] = Vertex.new(vertices[tuple[0]]) unless vertices[tuple[0]]
    vertices[tuple[1]] = Vertex.new(vertices[tuple[1]]) unless vertices[tuple[1]]
    Edge.new(vertices[tuple][1], vertices[tuple][0])

    max = tuple.max if tuple.max > max
  end

  (1..max).each do |i|
    independent << i unless verticies[i]
  end

  independent + topological_sort(vertices.values).map { |v| v.value }
end
