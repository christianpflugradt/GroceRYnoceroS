require_relative '../../common/inout'
require_relative '../../common/flow'

module AssignGroceries
  extend self, Flow

  class Item
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  class Grocery < Item
    attr_writer :index
  end

  class Category < Item
  end

  @hint_shop = <<HINT_CAT

  ----------------------------------
  [Select Categories for Assignment]

  Next to each category listed above is a number.
  If you want to assign groceries to any of these categories, input their numbers separated by comma.
  
  You can still decide not to assign any groceries to a selected category later,
  but you will not be offered to assign any groceries to a category you have not selected this time.
  
  Just press enter to return to the previous menu without assigning any groceries.
  --------------------------------------------------------------------------------

HINT_CAT

  @hint_cat = <<HINT_GRO

  ------------------
  [Assign Groceries]
    
  A maximum of 50 groceries are listed above. Next to each of them is a number.
    
  This hint will appear for each category you previously selected.
  As you assign groceries the list above becomes smaller and numbers are reused for other groceries.

  To assign groceries to the category suggested below input their numbers separated by comma.

  Just press enter to not assign any groceries to the currently suggested category.
  ---------------------------------------------------------------------------------

HINT_GRO

  @shops = []
  @categories = []

  def run(db)
    load_categories db
    if @shops.empty?
      print_nack "You don't have any categories in your database."
    else
      assign_per_category db
    end
  end

  def assign_per_category(db)
    print_list @shops
    print_usage_text @hint_shop
    filter_categories input_ids @shops.length, 'use these categories'
    load_groceries db
    @shops.each do |category|
      break unless assign_groceries_if_possible db, category
    end
  end

  def assign_groceries_if_possible(db, category)
    success = !@categories.empty?
    if success
      grocery_ids = prepare_assign_groceries category
      assign_groceries db, category, grocery_ids
    else
      print_ack 'All groceries have been assigned.'
    end
    success
  end

  def prepare_assign_groceries(category)
    print_list @categories
    print_usage_text @hint_cat
    (input_ids @categories.length, "assign to category '#{category.name}'")
      .map { |index| find_by_index index, @categories }
      .map(&:id)
  end

  def assign_groceries(db, category, grocery_ids)
    unless grocery_ids.empty?
      db.assign_groceries_to_category(grocery_ids, category.id)
      @categories.delete_if do |grocery|
        grocery_ids.include? grocery.id
      end
      update_grocery_indices
    end
    print_ack "#{grocery_ids.length} groceries have been assigned to category '#{category.name}'."
  end

  def find_by_index(id, list)
    list.find { |grocery| grocery.index == id }
  end

  def filter_categories(ids)
    @shops = @shops.filter do |item|
      ids.include? item.index
    end
  end

  def print_list(list)
    print_list_header
    list.each { |item| print_list_item item.index, item.name }
  end

  def load_categories(db)
    @shops.clear
    sql_result = db.select_all_categories
    begin
      sql_result.each_with_index do |row, index|
        @shops.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def load_groceries(db)
    @categories.clear
    sql_result = db.select_unassigned_groceries
    begin
      sql_result.each_with_index do |row, index|
        @categories.append Grocery.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def update_grocery_indices
    @categories.each_with_index do |grocery, index|
      grocery.index = index + 1
    end
  end

end
