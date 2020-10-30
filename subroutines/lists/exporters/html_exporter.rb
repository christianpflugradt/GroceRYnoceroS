require_relative '../../../common/inout'
require_relative '../../../common/flow'
require_relative 'base_exporter'

require 'os'

module HtmlExporter
  extend self, Flow, BaseExporter

  @placeholder = 'FILENAMEPLACEHOLDER'
  @hint_exp = <<HINT_EXP

  -------------
  [Export List]
    
  GroceRYnoceroS exported the shopping list to a file and attempted to open it.
  If the file did not open you can open it manually:
  #{@placeholder}

  Press enter to return to the previous menu.
  -------------------------------------------------------------

HINT_EXP

  def write(list_id, lines)
    filename = "grocerynoceros-shopping-list-#{list_id}.html"
    File.open(filename, 'w') do |file|
      begin
        file.write "<html><head><title>#{lines[0]}</title><body>"
        lines.filter { |line| !line.empty? }.map(&:strip).each do |line|
          first = line[0]
          case first
          when '['
            file.write "<h1>#{line[1..-2]}</h1>"
          when ':'
            file.write "<h2>#{line[1..-2]}</h2>"
          when '('
            file.write "<input type=\"checkbox\" id=\"#{line}\"><label for=\"#{line}\">#{line}</label><br>"
          end
        end
        file.write '</body></html>'
        print_usage_text @hint_exp.sub! @placeholder, (File.realpath filename).to_s
      ensure
        file.close
      end
      system %(#{OS.open_file_command} "#{filename}")
    end
  end

end
