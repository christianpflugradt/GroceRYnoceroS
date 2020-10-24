require_relative 'models'

module ListService
  extend self

  attr_accessor :id

  def retrieve(db)
    reset
    sql_result = db.view_shopping_list @id
    begin
      sql_result.each { |row| process_row row }
    ensure
      sql_result.close
    end
    build_list db
  end

  def retrieve_flat(db)
    retrieve(db).sections.flat_map(&:items)
  end

  def process_row(row)
    if @list_section&.name != row[3]
      @list_sections.append @list_section unless @list_section.nil?
      @list_section_items = []
      @list_section = ListSection.new row[3], @list_section_items
    end
    @list_section_items.append ListSectionItem.new row[0], row[1], @next_index
    @next_index += 1
  end

  def build_list(db)
    @list_sections.append @list_section unless @list_section.nil?
    List.new @id, db.get_list_name(@id), @list_sections
  end

  def reset
    @next_index = 1
    @list_section = nil
    @list_sections = []
    @list_section_items = []
  end

end
