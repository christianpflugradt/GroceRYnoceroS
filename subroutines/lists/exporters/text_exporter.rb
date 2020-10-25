require_relative '../../../common/inout'
require_relative '../../../common/flow'

require 'os'

module TextExporter
  extend self, Flow

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

  def run(db)
    list = ListService.retrieve db
    lines = []
    add_shopping_list_to_array list, lines
    write(list.id, lines)
  end

  def add_shopping_list_to_array(list, lines)
    lines.append "#{list.id} - #{list.name}\n"
    add_shops_to_array list.shops, lines
    lines
  end

  def add_shops_to_array(shops, lines)
    shops.each do |shop|
      lines.append "\n[#{shop.name}]" if shops.length > 1
      add_sections_to_array shop.sections, lines
    end
  end

  def add_sections_to_array(sections, lines)
    sections.each do |section|
      lines.append "\n#{section.name}"
      section.items.each do |item|
        lines.append "(#{item.index}) #{item.name}"
      end
    end
  end

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
