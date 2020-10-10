require_relative '../../common/inout'
require_relative '../../common/flow'

module RemoveCategoriesFromShops
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
  [Select Shops for Removing Categories]

  Next to each shop listed above is a number.
  If you want to remove categories from any of these shops, input their numbers separated by comma.
  
  You can still decide not to remove any categories from a selected shop later,
  but you will not be offered to remove any categories from a shop you have not selected this time.
  
  Just press enter to return to the previous menu without removing any categories.
  --------------------------------------------------------------------------------

HINT_SHOP

  @hint_cat = <<HINT_CAT

  ------------------
  [Remove Categories]
    
  This hint will appear for each shop you previously selected.

  Next to each category listed above is a number.    
  To remove categories from the shop suggested below input their numbers separated by comma.

  Just press enter to not remove any categories from the currently suggested shop.
  ---------------------------------------------------------------------------------

HINT_CAT

  @shops = []
  @categories = []

  def run(db)
    load_shops db
    if @shops.empty?
      print_nack "You don't have any shops in your database."
    else
      remove_per_shop db
    end
  end

  def remove_per_shop(db)
    print_list @shops
    print_usage_text @hint_shop
    filter_shops input_ids @shops.length, 'use these shops'
    @shops.each do |shop|
      load_categories_for_shop db, shop.id
      remove_categories_from_shop db, shop
    end
  end

  def remove_categories_from_shop(db, shop)
    if @categories.empty?
      print_nack "There are no categories added to shop '#{shop.name}'."
    else
      category_ids = prepare_remove_categories shop
      remove_given_categories db, shop, category_ids unless category_ids.empty?
    end
  end

  def prepare_remove_categories(shop)
    print_list @categories
    print_usage_text @hint_cat
    (input_ids @categories.length, "remove from shop '#{shop.name}'")
      .map { |index| find_by_index index, @categories }
      .map(&:id)
  end

  def remove_given_categories(db, shop, category_ids)
    db.remove_categories_from_shop shop.id, category_ids
    db.fix_category_priorities_for_shop shop.id
    print_ack "#{category_ids.length} categories have been removed from shop '#{shop.name}'."
  end

  def find_by_index(id, list)
    list.find { |category| category.index == id }
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
    sql_result = db.select_categories_in_shop shop_id
    begin
      sql_result.each_with_index do |row, index|
        @categories.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

end
