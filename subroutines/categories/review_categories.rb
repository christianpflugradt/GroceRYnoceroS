require_relative '../../common/inout'
require_relative '../../common/flow'

module ReviewCategories
  extend self, Flow

  class Category < Flow::Item
  end

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
    update_selection db
    delete_categories db unless @selection.empty?
    if @selection.empty?
      print_nack "You don't have any categories in your database."
    else
      rename_categories db
    end
  end

  def delete_categories(db)
    print_list @selection
    print_usage_text @hint_delete
    ids = input_ids max_id(@selection), 'delete these categories'
    unless ids.empty?
      db.delete_categories(ids.map { |index| find_by_index(index, @selection).id })
      print_ack "#{ids.length} categories have been deleted."
      update_selection db
    end
  end

  def rename_categories(db)
    print_list @selection
    print_usage_text @hint_rename
    ids = input_ids max_id(@selection), 'rename these categories'
    ids.each { |index| rename_category db, index }
  end

  def rename_category(db, index)
    category = find_by_index index, @selection
    new_name = input "enter new name for '#{category.name}'"
    if new_name.empty?
      print_nack "Category '#{category.name}' not renamed because of empty input."
    elsif db.category_exists? category.id, new_name
      print_nack "Category '#{category.name}' not renamed because category '#{new_name}' already exists."
    else
      db.rename_category category.id, new_name
      print_ack "Category '#{category.name}' renamed to '#{new_name}'."
    end
  end

  def update_selection(db)
    load_items db.select_all_categories, @selection, Category
  end

end
