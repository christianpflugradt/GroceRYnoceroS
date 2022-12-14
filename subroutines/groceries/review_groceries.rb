require_relative '../../common/inout'
require_relative '../../common/flow'

module ReviewGroceries
  extend self, Flow

  class Grocery < Flow::Item
  end

  @hint_filter = <<HINT_FIL

  ------------------
  [Review Groceries]
  
  A maximum of 99 groceries will be displayed.
  You can input a name filter to display only groceries that start with the letters in the filter.
  For example input the letter M to only match groceries such as Milk or Mushrooms.
  Or input the letters 'Bread' to only match groceries such as Breadstick or Gingerbread.

  Just press enter if you don't want to apply a filter.
  -----------------------------------------------------

HINT_FIL

  @hint_delete = <<HINT_DEL

  ------------------
  [Delete Groceries]

  Next to each grocery listed above is a number.
  If you want to delete any of the groceries listed, input their numbers separated by comma.
  For example enter '1,4,23' to permanently delete the groceries numbered 1, 4 and 23.

  Just press enter if you don't want to delete any of these groceries.
  --------------------------------------------------------------------
  
HINT_DEL

  @hint_rename = <<HINT_REN

  ------------------
  [Rename Groceries]

  Please note that the numbers may have changed if you deleted any groceries in the previous step.

  If you want to rename any of the groceries listed, input their numbers separated by comma.
  For example enter '1,4,23' to rename the groceries numbered 1, 4 and 23.

  Just press enter if you don't want to rename any of these groceries.
  --------------------------------------------------------------------

HINT_REN

  @selection = []

  def run(db)
    print_usage_text @hint_filter
    filter = input 'input a filter'
    update_selection db, filter
    delete_groceries db, filter unless @selection.empty?
    if @selection.empty?
      print_nack filter.empty? ?
        "You don't have any groceries in your database." :
        'There are no groceries matching your filter.'
    else
      rename_groceries db
    end
  end

  def delete_groceries(db, filter)
    print_list @selection
    print_usage_text @hint_delete
    ids = input_ids max_id(@selection), 'delete these groceries'
    unless ids.empty?
      db.delete_groceries(ids.map { |index| find_by_index(index, @selection).id })
      print_ack "#{ids.length} groceries have been deleted."
      update_selection db, filter
    end
  end

  def rename_groceries(db)
    print_list @selection
    print_usage_text @hint_rename
    ids = input_ids max_id(@selection), 'rename these groceries'
    ids.each { |index| rename_grocery db, index }
  end

  def rename_grocery(db, index)
    grocery = find_by_index index, @selection
    new_name = input "enter new name for '#{grocery.name}'"
    if new_name.empty?
      print_nack "Grocery '#{grocery.name}' not renamed because of empty input."
    elsif db.grocery_exists? grocery.id, new_name
      print_nack "Grocery '#{grocery.name}' not renamed because grocery '#{new_name}' already exists."
    else
      db.rename_grocery grocery.id, new_name
      print_ack "Grocery '#{grocery.name}' renamed to '#{new_name}'."
    end
  end

  def update_selection(db, filter)
    load_items db.select_groceries(filter), @selection, Grocery
  end

end
