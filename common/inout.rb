def input(prefix = '')
  print prefix, ' > '
  STDIN.gets.chomp.strip
end

def input_num(prefix = '')
  (input prefix).to_i
end

def input_ids(prefix = '')
  ((input prefix).split ',').map(&:to_i)
end

def print_info(text)
  puts "\n  INFO: #{text}"
end

def print_error(text)
  puts "\n  ERROR: #{text}\n\n"
end

def print_list_header
  puts "\n  ------------------------------"
end

def print_list_item(index, name)
  puts "  (#{index})\t#{name}"
end
