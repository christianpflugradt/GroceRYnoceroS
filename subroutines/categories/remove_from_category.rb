require_relative '../../common/inout'
require_relative '../../common/flow'

module RemoveFromCategory
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
  end

  class Category < Item
    attr_writer :index
  end

  @hint_cat = <<HINT_CAT

  -----------------
  [Choose Category]

  Enter the first letters of a category to search for it
  or just press enter to search for all categories (up to 99 maximum).

  Once search has been executed, suitable categories will be displayed.
  Next to each category will be a number.

  Input the number of the category you want to remove groceries from.
  You can only update one category at a time. Do not enter multiple numbers.
  --------------------------------------------------------------------------

HINT_CAT

  @hint_gro = <<HINT_GRO
  -----------------------------------------
  [Remove Groceries from Selected Category]

  Next to each grocery listed above is a number.
  If you want to remove groceries from the selected category, input their numbers separated by comma.

  Only up to 99 groceries are listed. If the category contains more groceries,
  the next batch of groceries will be displayed after you have confirmed your choice.
  To remove all displayed groceries from the category

  Removed groceries will become unassigned.
  They can be assigned to another category from the menu 'Manage Groceries'.

  If you don't want to remove any of the groceries listed above, just press enter.
  --------------------------------------------------------------------------------

HINT_GRO

  @categories = []
  @groceries = []

  def run(db)
    print_usage_text @hint_cat
    filter = input 'input a filter'
    load_categories db, filter
    if @categories.empty?
      print_nack filter.empty? ?
                     "You don't have any categories in your database." :
                     'There are no categories matching your filter.'
    else
      remove_from_category db
    end
  end

  def remove_from_category(db)
    print_list @categories
    category = find_by_index(input_num('remove from this category'), @categories)
    if category.nil?
      print_error 'Category number is invalid.'
    else
      load_groceries db, category.id
      if @groceries.empty?
        print_error "Category '#{category.name}' does not have any groceries assigned."
      else
        remove_from_category_batched db, category
      end
    end
  end

  def remove_from_category_batched(db, category)
    @groceries.each do |batch|
      print_list batch
      print_usage_text @hint_gro
      groceries = input_ids(batch.length, "remove from category '#{category.name}'")
                  .map { |index| find_by_index index, batch }.map(&:id)
      db.remove_groceries_from_category category.id, groceries
      print_ack "#{groceries.length} groceries removed from category '#{category.name}'."
    end
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
    stdout ''
  end

  def load_categories(db, filter)
    @categories.clear
    sql_result = db.select_categories filter
    begin
      sql_result.each_with_index do |row, index|
        @categories.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def load_groceries(db, id)
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

  def update_grocery_indices
    @groceries.each_with_index do |grocery, index|
      grocery.index = index + 1
    end
  end

end
