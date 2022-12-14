require_relative '../../common/inout'
require_relative '../../common/flow'

module RemoveFromCategory
  extend self, Flow

  class Grocery < Flow::Item
  end

  class Category < Flow::Item
    attr_writer :index
  end

  @hint_cat = <<HINT_CAT

  -----------------
  [Choose Category]

  Next to each category listed above is a number.

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
    load_categories db
    if @categories.empty?
      print_nack "You don't have any categories in your database."
    else
      remove_from_category db
    end
  end

  def remove_from_category(db)
    print_list @categories
    print_usage_text @hint_cat
    category = find_by_index(input_num('remove from this category'), @categories)
    if category.nil?
      print_nack 'Category number is invalid.'
    else
      load_groceries db, category.id
      if @groceries.empty?
        print_nack "Category '#{category.name}' does not have any groceries assigned."
      else
        remove_from_category_batched db, category
      end
    end
  end

  def remove_from_category_batched(db, category)
    @groceries.each do |batch|
      print_list batch
      print_usage_text @hint_gro
      groceries = input_ids(max_id(batch), "remove from category '#{category.name}'")
                  .map { |index| find_by_index index, batch }.map(&:id)
      db.remove_groceries_from_category category.id, groceries
      print_ack "#{max_id(groceries)} groceries removed from category '#{category.name}'."
    end
  end

  def load_categories(db)
    load_items db.select_all_categories, @categories, Category
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

end
