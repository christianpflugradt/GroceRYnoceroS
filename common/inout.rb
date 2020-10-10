require 'colorize'

def input(prefix = '')
  print prefix.white, ' > '.white
  STDIN.gets.chomp.strip
end

def input_num(prefix = '')
  (input prefix).to_i
end

def input_ids(max_id, prefix = '')
  inp = ((input prefix).split ',').map(&:to_i)
  inp.include?(-1) ?
      1..max_id :
      inp.filter { |id| (1..max_id).include? id }
end

def print_ack(text)
  puts text.green
end

def print_nack(text)
  puts text.red
end

def print_list_header
  puts "\n  ------------------------------".blue
end

def print_list_item(index, name)
  puts "  (#{index})\t#{name}".blue
end

def print_list_subheader(name)
  puts "\n  #{name}".blue
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

def stdout(*text)
  text.each { |str| puts str.white }
end
