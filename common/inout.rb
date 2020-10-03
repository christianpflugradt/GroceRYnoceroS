def input(prefix = '')
  print prefix, ' > '
  STDIN.gets.chomp.strip
end

def input_num(prefix = '')
  (input prefix).to_i
end

def input_ids(prefix = '')
  ((input prefix).split ',').map &:to_i
end
