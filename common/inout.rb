require 'colorize'

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

def print_ack(text)
  puts text.green
end

def print_nack(text)
  puts text.red
end

def print_error(text)
  puts text.red.bold
end

def print_list_header
  puts "\n  ------------------------------".blue
end

def print_list_item(index, name)
  puts "  (#{index})\t#{name}".blue
end

def print_menu_text(menu_text)
  puts menu_text.cyan
end

def print_banner_text(banner_string)
  puts banner_string.magenta
end

def print_usage_text(info_text)
  puts info_text.yellow
end