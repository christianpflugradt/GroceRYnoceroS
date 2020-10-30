require_relative '../../common/inout'
require_relative '../../common/flow'
require_relative '../../common/list/list_service'

module AddGroceriesByFilter
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
    attr_writer :index
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
    
  A maximum of 99 groceries will be displayed.
  You can input a name filter to display only groceries that start with the letters in the filter.
  For example input the letter M to only match groceries such as Milk or Mushrooms.
  Or input the letters 'Bread' to only match groceries such as Breadstick or Gingerbread.

  Just press enter if you don't want to add any of the listed groceries to your list.
  -----------------------------------------------------------------------------------

HINT_GRO

  @ids_in_list = []
  @shops = []
  @groceries = []

  def run(db)
    load_shops db
    print_list @shops
    print_usage_text @hint_shop
    if @shops.empty?
      print_nack "You don't have any shops in your database."
    else
      @ids_in_list = ListService.retrieve_flat(db).map(&:id)
      select_shop_and_continue db
    end
  end

  def select_shop_and_continue(db)
    shop = find_by_index(input_num('add groceries from this shop'), @shops)
    if shop.nil?
      print_nack 'Shop number is invalid.'
    else
      set_filter_and_continue db, shop
    end
  end

  def set_filter_and_continue(db, shop)
    filter = input 'input a filter'
    unless filter.empty?
      load_groceries_for_shop db, shop.id, filter
      @groceries = filter_to_non_included @groceries, @ids_in_list
      if @groceries.empty?
        print_nack 'There are no groceries matching your filter.'
      else
        list_groceries_and_continue db, shop
      end
    end
  end

  def list_groceries_and_continue(db, shop)
    print_list @groceries
    grocery_ids = (input_ids max_id(@groceries), 'add to list')
                      .map { |index| find_by_index index, @groceries }
                      .map(&:id)
    unless grocery_ids.empty?
      list_id = ListService.id
      db.add_groceries_to_list list_id, shop.id, grocery_ids
      print_ack "#{grocery_ids.length} groceries have been added to the list."
    end
  end

  def load_shops(db)
    load_items db.select_all_shops, @shops, Shop
  end

  def load_groceries_for_shop(db, shop_id, filter)
    load_items db.select_groceries_for_shop(shop_id, filter), @groceries, Grocery
  end

end
