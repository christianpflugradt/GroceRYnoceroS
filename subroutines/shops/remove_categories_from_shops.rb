require_relative '../../common/inout'
require_relative '../../common/flow'

module AddCategoriesToShops
  extend self, Flow

  class Item
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  class Category < Item
  end

  class Shop < Item
  end

  @hint_shop = <<HINT_SHOP

  ----------------------------------
  [Select Shops for Adding Categories]

  Next to each shop listed above is a number.
  If you want to add categories to any of these shops, input their numbers separated by comma.
  
  You can still decide not to add any categories to a selected shop later,
  but you will not be offered to add any categories to a shop you have not selected this time.
  
  Just press enter to return to the previous menu without adding any categories.
  --------------------------------------------------------------------------------

HINT_SHOP

  @hint_cat = <<HINT_CAT

  ------------------
  [Add Categories]
    
  This hint will appear for each shop you previously selected.

  Next to each category listed above is a number.    
  To add categories to the shop suggested below input their numbers separated by comma.

  Note that the order of numbers input will be used as the order of categories for that shop.
  However if that shop already has other categories added,
  then the categories added this time will be appended at the end.

  You can fine tune the order of categories for a shop or remove categories from a shop
  by selecting the respective Flows from the previous menu.

  Just press enter to not add any categories to the currently suggested shop.
  ---------------------------------------------------------------------------------

HINT_CAT

  @shops = []
  @categories = []

  def run(db)
    load_shops db
    if @shops.empty?
      print_error "You don't have any shops in your database."
    else
      add_per_shop db
    end
  end

  def add_per_shop(db)
    print_list @shops
    print_usage_text @hint_shop
    filter_shops input_ids @shops.length, 'use these shops'
    @shops.each do |shop|
      load_categories_for_shop db, shop.id
      add_categories_to_shop db, shop
    end
  end

  def add_categories_to_shop(db, shop)
    if @categories.empty?
      print_error "All categories have already been added to shop '#{shop.name}'."
    else
      category_ids = prepare_add_categories shop
      add_given_categories db, shop, category_ids unless category_ids.empty?
    end
  end

  def prepare_add_categories(category)
    print_list @categories
    print_usage_text @hint_cat
    (input_ids @categories.length, "assign to category '#{category.name}'")
      .map { |index| find_by_index index, @categories }
      .map(&:id)
  end

  def add_given_categories(db, shop, category_ids)
    min_priority = db.select_max_category_priority_for_shop(shop.id) + 1
    db.add_categories_to_shop category_ids, shop.id, min_priority
    print_ack "#{category_ids.length} categories have been added to shop '#{shop.name}'."
  end

  def find_by_index(id, list)
    list.find { |grocery| grocery.index == id }
  end

  def filter_shops(ids)
    @shops = @shops.filter do |item|
      ids.include? item.index
    end
  end

  def print_list(list)
    print_list_header
    list.each { |item| print_list_item item.index, item.name }
  end

  def load_shops(db)
    @shops.clear
    sql_result = db.select_all_shops
    begin
      sql_result.each_with_index do |row, index|
        @shops.append Shop.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def load_categories_for_shop(db, shop_id)
    @categories.clear
    sql_result = db.select_categories_not_in_shop shop_id
    begin
      sql_result.each_with_index do |row, index|
        @categories.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

end
