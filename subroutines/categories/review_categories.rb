require_relative '../../common/inout'
require_relative '../../common/flow'

module ReviewCategories
  extend self, Flow

  class Category
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  @hint_filter = <<HINT_FIL

  -------------------
  [Review Categories]
  
  A maximum of 99 categories will be displayed.
  You can input a name filter to display only categories that start with the letters in the filter.
  For example input the letter M to only match categories such as Milk products or Meat.
  Or input the letters 'Veg' to only match categories such as Vegetables and Vegetarian dishes.

  Just press enter if you don't want to apply a filter.
  -----------------------------------------------------

HINT_FIL

  @hint_delete = <<HINT_DEL

  -------------------
  [Delete Categories]

  Next to each category listed above is a number.
  If you want to delete any of the categories listed, input their numbers separated by comma.
  For example enter '1,4,23' to permanently delete the categories numbered 1, 4 and 23.

  Be aware that any categories assigned to these categories will become unassigned!

  Just press enter if you don't want to delete any of these categories.
  ---------------------------------------------------------------------

HINT_DEL

  @hint_rename = <<HINT_REN

  -------------------
  [Rename Categories]

  Please note that the numbers may have changed if you deleted any categories in the previous step.

  If you want to rename any of the categories listed, input their numbers separated by comma.
  For example enter '1,4,23' to rename the categories numbered 1, 4 and 23.

  Just press enter if you don't want to rename any of these categories.
  ---------------------------------------------------------------------

HINT_REN

  @selection = []

  def run(db)
    print_usage_text @hint_filter
    filter = input 'input a filter'
    update_selection db, filter
    delete_categories db, filter unless @selection.empty?
    if @selection.empty?
      print_nack filter.empty? ?
                     "You don't have any categories in your database." :
                     'There are no categories matching your filter.'
    else
      rename_categories db
    end
  end

  def delete_categories(db, filter)
    print_selection
    print_usage_text @hint_delete
    ids = input_ids max_id, 'delete these categories'
    unless ids.empty?
      db.delete_categories(ids.map { |index| find_category_by_index(index).id })
      print_ack "#{ids.length} categories have been deleted."
      update_selection db, filter
    end
  end

  def rename_categories(db)
    print_selection
    print_usage_text @hint_rename
    ids = input_ids max_id, 'rename these categories'
    ids.each { |index| rename_category db, index }
  end

  def rename_category(db, index)
    category = find_category_by_index index
    new_name = input "enter new name for '#{category.name}'"
    if new_name.empty?
      print_nack "Category '#{category.name}' not renamed because of empty input."
    elsif db.category_exists? category.id, new_name
      print_error "Category '#{category.name}' not renamed because category '#{new_name}' already exists."
    else
      db.rename_category category.id, new_name
      print_ack "Category '#{category.name}' renamed to '#{new_name}'."
    end
  end

  def find_category_by_index(id)
    @selection.find { |category| category.index == id }
  end

  def print_selection
    print_list_header
    @selection.each { |category| print_list_item category.index, category.name }
  end

  def update_selection(db, filter)
    @selection.clear
    sql_result = db.select_categories filter
    begin
      sql_result.each_with_index do |row, index|
        @selection.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def max_id
    @selection.length
  end

end
