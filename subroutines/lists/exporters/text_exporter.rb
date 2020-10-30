require_relative '../../../common/inout'
require_relative '../../../common/flow'
require_relative 'base_exporter'

require 'os'

module TextExporter
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
    filename = "grocerynoceros-shopping-list-#{list_id}.txt"
    File.open(filename, 'w') do |file|
      begin
        file.write lines.join "\n"
        print_usage_text @hint_exp.sub! @placeholder, (File.realpath filename).to_s
      ensure
        file.close
      end
      system %(#{OS.open_file_command} "#{filename}")
    end
  end

end
