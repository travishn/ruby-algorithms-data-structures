require_relative 'p05_hash_map'

def can_string_be_palindrome?(string) 
  hash_map = HashMap.new
  
  string.each_char do |letter|
    current_val = hash_map.get(letter)
    
    if current_val 
      new_val = hash_map.get(letter) + 1
    else
      new_val = 1
    end

    hash_map.set(letter, new_val)
  end


  odd_count = 0
  string.each_char do |letter|
    odd_count += 1 if hash_map.get(letter).odd?
  end

  return odd_count == 0 || odd_count == 1
end
