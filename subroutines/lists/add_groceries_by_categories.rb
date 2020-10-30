require_relative '../../common/inout'
require_relative '../../common/flow'
require_relative '../../common/list/list_service'

module AddGroceriesByCategories
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

  class Grocery < Flow::Item
  end

  class Category < Flow::Item
  end

  class Shop < Flow::Item
  end


  @hint_shop = <<HINT_SHOP

  ----------------------
  [Select Shop for List]

  Next to each shop listed above is a number.
  Input the number of the shop you want to select groceries from.

  Just press enter to return to the previous menu without adding any groceries to the list.
  -----------------------------------------------------------------------------------------

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

  @ids_in_list = []
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
      @ids_in_list = ListService.retrieve_flat(db).map(&:id)
      select_shop_and_create_list db
    end
  end

  def select_shop_and_create_list(db)
    shop = find_by_index(input_num('add groceries from this shop'), @shops)
    if shop.nil?
      print_nack 'Shop number is invalid.'
    else
      load_categories_for_shop db, shop.id
      list_id = ListService.id
      process_categories db, list_id, shop.id
    end
  end

  def process_categories(db, list_id, shop_id)
    @categories.each do |category|
      process_category db, category, list_id, shop_id
    end
  end

  def process_category(db, category, list_id, shop_id)
    load_groceries_for_category db, category.id
    unless @groceries.empty?
      @groceries.each_with_index do |batch, index|
        stdout "\n#{category.name} #{index + 1}/#{@groceries.length}"
        print_list batch
        grocery_ids = (input_ids batch.length, 'add to list')
                      .map { |index| find_by_index index, batch }
                      .map(&:id)
        unless grocery_ids.empty?
          db.add_groceries_to_list list_id, shop_id, grocery_ids
          print_ack "#{grocery_ids.length} groceries have been added to the list."
        end
      end
    end
  end

  def load_shops(db)
    load_items db.select_all_shops, @shops, Shop
  end

  def load_categories_for_shop(db, shop_id)
    load_items db.select_categories_in_shop(shop_id), @categories, Category
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
    sql_result.filter { |row| !@ids_in_list.include? row[0] }.each_with_index do |row, index|
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
