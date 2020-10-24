require_relative 'create_list'
require_relative 'add_groceries_by_categories'
require_relative 'remove_groceries'
require_relative 'export_list'
require_relative '../../common/list/list_service'

module ManageLists
  extend self, Menu

  @subroutines = %i[
    enter_create_list_sub
    enter_groceries_categories_sub
    enter_groceries_filter_sub
    enter_groceries_remove_sub
    enter_export_sub
  ]

  @menu_here_doc = <<MENU

  [Manage Lists]

  (1) create a new list
  (2) add groceries by category
  (3) [tbd] add groceries by filter
  (4) remove groceries from list
  (5) export list
  (6) return to previous menu

MENU

  def id
    ListService.id
  end

  def dynamic_menu
    text = id.nil? ? 'No list set. Load a list or create a new one.' : "List with id #{id} set. Happy shopping!"
    "#{@menu_here_doc}  #{text}\n"
  end

  def enter_create_list_sub(db)
    CreateList.enter self, db
  end

  def enter_groceries_categories_sub(db)
    AddGroceriesByCategories.enter self, db if list_set?
  end

  def enter_groceries_filter_sub(db)
    stdout 'not yet implemented :(' if list_set?
  end

  def enter_groceries_remove_sub(db)
    RemoveGroceries.enter self, db if list_set?
  end

  def enter_export_sub(db)
    ExportList.enter self, db if list_set?
  end

  def list_set?
    print_nack 'Create or load a list first' if id.nil?
    !id.nil?
  end

end
