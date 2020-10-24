require_relative 'models'

module ListService
  extend self

  attr_accessor :list_id

  @list_section = nil
  @list_sections = []
  @list_section_items = []

  def retrieve(db)
    reset
    sql_result = db.view_shopping_list @list_id
    begin
      sql_result.each { |row| process_row row }
    ensure
      sql_result.close
    end
    build_list db
  end

  def process_row(row)
    if @list_section&.name != row[3]
      @list_sections.append @list_section unless @list_section.nil?
      @list_section_items = []
      @list_section = ListSection.new row[3], @list_section_items
    end
    @list_section_items.append ListSectionItem.new row[0], row[1]
  end

  def build_list(db)
    @list_sections.append @list_section unless @list_section.nil?
    List.new @list_id, db.get_list_name(list_id), @list_sections
  end

  def reset
    @list_section = nil
    @list_sections = []
    @list_section_items = []
  end

end
