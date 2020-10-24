require 'clipboard'

require_relative '../../common/inout'
require_relative '../../common/flow'
require_relative '../../common/export/loader'
require_relative '../../common/export/exporter'

module CreateSingleShopList
  extend self, Flow

  class ListItem
    attr_reader :id, :name, :cat, :index

    def initialize(id, name, cat, index)
      @id = id
      @name = name
      @cat = cat
      @index = index
    end
  end

  class Item
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  class Grocery < Item
  end

  class Category < Item
  end

  class Shop < Item
  end


  @hint_shop = <<HINT_SHOP

  ----------------------
  [Select Shop for List]

  Next to each shop listed above is a number.
  Input the number of the shop you want to create a list for.

  You can only select one shop. If you want to create a list spanning multiple shops
  please return to the previous menu and choose the respective Flow.

  Just press enter to return to the previous menu without creating a single shop list.
  ------------------------------------------------------------------------------------

HINT_SHOP

  @hint_gro = <<HINT_GRO

  ---------------------------
  [Select Groceries for List]
    
  For each category associated with the selected shop all groceries will be listed.

  Only up to 50 groceries will be listed at a time.
  If a category contains more than 50 groceries,
  the next batch of groceries will be listed once the current one has been processed.
  
  Next to each grocery listed will be a number.
  To add groceries to your list, input their numbers separated by comma.

  Just press enter if you don't want to add any of the listed groceries to your list.

  Once your list is complete you will have the opportunity
  to remove any groceries from your list that you added by mistake.
  -----------------------------------------------------------------

HINT_GRO

  @hint_rem = <<HINT_REM

  ---------------------------------------
  [Optionally Remove Groceries from List]
    
  Above you see a preview of the shopping list.
  Next to each grocery on the list is a number.

  If you want to remove any of them from the list, input their numbers separated by comma.
  ----------------------------------------------------------------------------------------

HINT_REM

  @shops = []
  @categories = []
  @groceries = []
  @list_items = []

  def run(db)
    load_shops db
    print_list @shops
    print_usage_text @hint_shop
    if @shops.empty?
      print_nack "You don't have any shops in your database."
    else
      select_shop_and_create_list db
    end
  end

  def select_shop_and_create_list(db)
    shop = find_by_index(input_num('create list for this shop'), @shops)
    if shop.nil?
      print_nack 'Shop number is invalid.'
    else
      load_categories_for_shop db, shop.id
      list_id = db.create_single_shop_list shop.id
      process_categories db, list_id
      offer_removals db, list_id
      Exporter.list_id = list_id
      Exporter.enter ManageLists, db
      # export_list list_id
    end
  end

  def process_categories(db, list_id)
    @categories.each do |category|
      process_category db, category, list_id
    end
  end

  def process_category(db, category, list_id)
    load_groceries_for_category db, category.id
    unless @groceries.empty?
      @groceries.each_with_index do |batch, index|
        stdout "\n#{category.name} #{index + 1}/#{@groceries.length}"
        print_list batch
        grocery_ids = (input_ids batch.length, 'add to list')
                      .map { |index| find_by_index index, batch }
                      .map(&:id)
        unless grocery_ids.empty?
          db.add_groceries_to_list list_id, grocery_ids
          print_ack "#{grocery_ids.length} groceries have been added to the list."
        end
      end
    end
  end

  def offer_removals(db, list_id)
    load_list db, list_id
    print_shopping_list
    print_usage_text @hint_rem
    grocery_ids = (input_ids @list_items.length, 'remove from list')
                  .map { |index| find_by_index index, @list_items }
                  .map(&:id)
    unless grocery_ids.empty?
      db.remove_from_list list_id, grocery_ids
      print_ack "#{grocery_ids.length} have been removed from the list."
      load_list db, list_id
    end
  end

  def find_by_index(id, list)
    list.find { |category| category.index == id }
  end

  def print_list(list)
    print_list_header
    list.each { |item| print_list_item item.index, item.name }
    stdout ''
  end

  def print_shopping_list
    print_list_header
    last_cat = nil
    @list_items.each do |item|
      if item.cat != last_cat
        print_list_subheader item.cat
        last_cat = item.cat
      end
      print_list_item item.index, item.name
    end
  end

  def load_list(db, list_id)
    @list_items.clear
    sql_result = db.view_shopping_list list_id
    begin
      sql_result.each_with_index do |row, index|
        @list_items.append ListItem.new row[0], row[1], row[2], index + 1
      end
    ensure
      sql_result.close
    end
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

  def load_groceries_for_category(db, id)
    @groceries.clear
    sql_result = db.select_groceries_by_category id
    begin
      load_groceries_batched sql_result
    ensure
      sql_result.close
    end
  end

  def load_groceries_batched(sql_result)
    batch = []
    sql_result.each_with_index do |row, index|
      modulo = (index % 50)
      if modulo.zero?
        @groceries.append batch unless batch.empty?
        batch = []
      end
      batch.append Grocery.new row[0], row[1], modulo + 1
    end
    @groceries.append batch unless batch.empty?
  end

end
