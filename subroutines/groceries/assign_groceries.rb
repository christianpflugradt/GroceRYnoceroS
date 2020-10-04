require_relative '../../common/inout'
require_relative '../../common/script'

module AssignGroceries
  extend self, Script

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

  @hint_cat = <<HINT_CAT

  ----------------------------------
  [Select Categories for Assignment]

  Next to each category listed above is a number.
  If you want to assign groceries to any of these categories, input their numbers separated by comma.
  
  You can still decide not to assign any groceries to a selected category later,
  but you will not be offered to assign any groceries to a category you have not selected this time.
  
  Just press enter to return to the previous menu without assigning any groceries.
  --------------------------------------------------------------------------------

HINT_CAT

  @hint_gro = <<HINT_GRO

  ------------------
  [Assign Groceries]
    
  A maximum of 50 groceries are listed above. Next to each of them is a number.
    
  This hint will appear for each category you previously selected.
  As you assign groceries the list above becomes smaller and numbers are reused for other groceries.

  To assign groceries to the category suggested below input their numbers separated by comma.

  Just press enter to not assign any groceries to the currently suggested category.
  ---------------------------------------------------------------------------------

HINT_GRO

  @categories = []
  @groceries = []

  def run(db)
    load_categories db
    if @categories.empty?
      print_info "You don't have any categories in your database."
    else
      assign_per_category db
    end
  end

  def assign_per_category(db)
    print_list @categories
    puts @hint_cat
    filter_categories input_ids 'use these categories'
    load_groceries db
    @categories.each do |category|
      break unless assign_groceries_if_possible db, category
    end
  end

  def assign_groceries_if_possible(db, category)
    success = !@groceries.empty?
    if success
      assign_groceries db, category
    else
      print_info 'All groceries have been assigned.'
    end
    success
  end

  def assign_groceries(db, category)
    print_list @groceries
    puts @hint_gro
    grocery_ids = (input_ids "assign to category '#{category.name}'")
                  .map { |index| find_by_index index, @groceries }.map(&:id)
    db.assign_groceries_to_category(grocery_ids, category.id)
    @groceries.delete_if do |grocery|
      grocery_ids.include? grocery.id
    end
    update_grocery_indices
  end

  def find_by_index(id, list)
    list.find { |grocery| grocery.index == id }
  end

  def filter_categories(ids)
    @categories = @categories.filter do |item|
      ids.include? item.index
    end
  end

  def print_list(list)
    print_list_header
    list.each { |item| print_list_item item.index, item.name }
  end

  def load_categories(db)
    @categories.clear
    sql_result = db.select_all_categories
    begin
      sql_result.each_with_index do |row, index|
        @categories.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def load_groceries(db)
    @groceries.clear
    sql_result = db.select_unassigned_groceries
    begin
      sql_result.each_with_index do |row, index|
        @groceries.append Grocery.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def update_grocery_indices
    @groceries.each_with_index do |grocery, index|
      grocery.index = index + 1
    end
  end

end
