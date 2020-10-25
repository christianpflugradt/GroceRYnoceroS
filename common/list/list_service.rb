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
    result = retrieve(db).shops
    if result.empty?
      []
    elsif result.flat_map(&:sections).empty?
      []
    else
      result.flat_map(&:sections).flat_map(&:items)
    end
  end

  def process_row(row)
    start_new_shop row if @list_shop&.name != row[5]
    start_new_section row if @list_section&.name != row[3]
    @list_section_items.append ListShopSectionItem.new row[0], row[1], @next_index
    @next_index += 1
  end

  def start_new_shop(row)
    @list_shops.append @list_shop unless @list_shop.nil?
    @list_sections = []
    @list_shop = ListShop.new row[5], @list_sections
  end

  def start_new_section(row)
    @list_sections.append @list_section unless @list_section.nil?
    @list_section_items = []
    @list_section = ListShopSection.new row[3], @list_section_items
  end

  def build_list(db)
    @list_sections.append @list_section unless @list_section.nil?
    @list_shops.append @list_shop unless @list_shop.nil?
    List.new @id, db.get_list_name(@id), @list_shops
  end

  def reset
    @next_index = 1
    @list_shop = nil
    @list_shops = []
    @list_section = nil
    @list_sections = []
    @list_section_items = []
  end

end
