require 'byebug'
class DynamicProgramming

  def initialize
    @blair_cache = { 1 => 1, 2 => 2 }
    @frog_cache = { 1 => [[1]], 2 => [[1,1], [2]], 3 => [[1,1,1], [2, 1], [1,2], [3]] }
    @maze_cache = {}
  end

  def blair_nums(n)
    return @blair_cache[n] unless @blair_cache[n].nil?
    odd_num = (2 * (n-1) - 1)

    ans = blair_nums(n-1) + blair_nums(n-2) + odd_num
    @blair_cache[n] = ans
    return ans
  end

  def frog_hops_bottom_up(n)
    cache = frog_cache_builder(n)
    cache[n]
  end

  def frog_cache_builder(n)
    cache = { 1 => [[1]], 2 => [[1,1], [2]], 3 => [[1,1,1], [2, 1], [1,2], [3]] }
    return cache if n < 4

    (4..n).each do |i|
      new_arr = cache[i-1].map { |arr| arr + [1] }
      new_arr += cache[i-2].map { |arr| arr + [2] }
      new_arr += cache[i-3].map { |arr| arr + [3] }

      cache[i] = new_arr
    end

    cache
  end

  def lec_frog_cache_builder(n)
    ways_collection = [[[], [[1]], [[1, 1]], [2]]]
    return ways_collection if n < 3

    (3..n).each do |i|
      new_way_set = []

      (1..3).each do |first_step|
        ways_collection[i - first_step].each do |way|
          new_way = [first_step]

          way.each do |step|
            new_way << step
          end

          new_way_set << new_way
        end
      end

      ways_collection << new_way_set
    end

    ways_collection
  end

  def frog_hops_top_down(n)
    frog_hops_top_down_helper(n)
  end

  def frog_hops_top_down_helper(n)
    return @frog_cache[n] if n < 4

    entry = frog_hops_top_down_helper(n-1).map { |arr| arr + [1] } + 
      frog_hops_top_down_helper(n-2).map { |arr| arr + [2] } + 
      frog_hops_top_down_helper(n-3).map { |arr| arr + [3] }
    @frog_cache[n] = entry
  end

  def lec_frog_hops_top_down_helper(n)
    return @frog_cache[n] if @frog_cache[n]
    new_way_set = []

    (1..3).each do |first_step|
      lec_frog_hops_top_down_helper(n - first_step).each do |way|
        new_way = [first_step]

        way.each do |step|
          new_way << step
        end

        new_way_set << new_way
      end
    end

    @froggy_cache[n] = new_way_set
  end

  def super_frog_hops(n, k)
    cache = super_frog_cache_builder(n, k)
    return cache[n]
  end
  
  def super_frog_cache_builder(n, k)
    cache = { 0 => [[]], 1 => [[1]] }
    
    (2..n).each do |i|
      result = []
      (1..k).each do |j|
        break if j > i
        cache[i-j].each do |arr|
          result << arr + [j]
        end

        cache[i] = result
      end
    end

    return cache
  end

  def lec_super_frog_cache_builder(n, k)
    ways_collection = [[[], [[1]]]]
    return ways_collection if n < 2

    (2..n).each do |i|
      new_way_set = []

      (1..k).each do |first_step|
        break if first_step > i
        ways_collection[i - first_step].each do |way|
          new_way = [first_step]

          way.each do |step|
            new_way << step
          end

          new_way_set << new_way
        end
      end

      ways_collection << new_way_set
    end

    ways_collection[n]
  end

  def knapsack(weights, values, capacity)
    return 0 if weights.length == 0 || capacity == 0
    solution_table = knapsack_table(weights, values, capacity)
    solution_table[capacity][-1]
  end

  # Helper method for bottom-up implementation
  def knapsack_table(weights, values, capacity)
    solution_table = []

    (0..capacity).each do |i|
      solution_table[i] = []

      (0...weights.length).each do |j|
        if i == 0 
          solution_table[i][j] = 0
        elsif j == 0
          solution_table[i][j] = weights[j] > i ? 0 : values[j]
        else
          option1 = solution_table[i][j-1]
          option2 = weights[j] > i ? 0 : solution_table[i - weights[j]][j-1] + values[j]
          optimum = [option1, option2].max

          solution_table[i][j] = optimum
        end
      end
    end

    solution_table
  end

  def maze_solver(maze, start_pos, end_pos)
    build_cache(start_pos)
    solve_maze(maze, start_pos, end_pos)
    find_path(end_pos)
  end

  private

  def solve_maze(maze, start_pos, end_pos)
    return true if start_pos == end_pos

    get_moves(maze, start_pos).each do |next_pos|
      unless @maze_cache.keys.include?(next_pos)
        @maze_cache[next_pos] = start_pos
        solve_maze(maze, next_pos, end_pos)
      end
    end
  end

  def build_cache(start_pos)
    @maze_cache[start_pos] = nil
  end

  def find_path(end_pos)
    path = []
    current = end_pos

    until current.nil?
      path.unshift(current)
      current = @maze_cache[current]
    end

    path
  end

  def get_moves(maze, from_pos)
    directions = [[0, 1], [1, 0], [-1, 0], [0, -1]]
    x, y = from_pos
    result = []

    directions.each do |dx, dy|
      next_pos = [x + dx, y + dy]
      result << next_pos if is_valid_pos?(maze, next_pos)
    end

    result
  end

  def is_valid_pos?(maze, pos)
    x, y = pos
    x >= 0 && y >= 0 && x < maze.length && y < maze.first.length && maze[x][y] != "X"
  end
end
