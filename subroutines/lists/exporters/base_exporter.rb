require_relative '../../../common/inout'
require_relative '../../../common/flow'

module BaseExporter

  def run(db)
    list = ListService.retrieve db
    lines = []
    add_shopping_list_to_array list, lines
    write(list.id, lines)
    input 'press enter to continue'
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
    # implement this function when extending this exporter
  end

end
