require_relative '../../../common/inout'

require 'os'

module AbstractFileExporter

  def run(db)
    list = ListService.retrieve db
    write_file list
    input 'press enter to continue'
  end

  def placeholder
    'FILENAMEPLACEHOLDER'
  end

  def hint
    <<HINT_EXP

  -------------
  [Export List]
    
  GroceRYnoceroS exported the shopping list to a file and attempted to open it.
  If the file did not open you can open it manually:
  #{placeholder}

  Press enter to return to the previous menu.
  -------------------------------------------------------------

HINT_EXP
  end

  def write_file(list)
    filename = "grocerynoceros-#{list.id}.#{@file_extension}"
    File.open(filename, 'w') do |file|
      begin
        write file, list
      ensure
        file.close
      end
    end
    print_usage_text hint.sub! placeholder, (File.realpath filename).to_s
    system %(#{OS.open_file_command} "#{filename}")
  end

  def write(file, list)
    # implement this function when extending this exporter
  end

end
