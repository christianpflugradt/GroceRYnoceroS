require_relative '../common/menu'
require_relative 'manage_groceries'

module Main
  extend self, Menu

  @main = true
  @subroutines = [
      :enter_create_list_sub,
      :enter_manage_items_sub,
      :enter_manage_categories_sub,
      :enter_manage_shops_sub,
      :enter_import_shopping_data
  ]

  @menu = <<MENU

  [Main]

  (1) create a shopping list
  (2) manage shopping items
  (3) manage item categories
  (4) manage shops
  (5) import shopping data
  (6) quit GroceRYinoceroS

MENU

  def enter_create_list_sub(db)
    puts "not yet implemented :("
  end

  def enter_manage_items_sub(db)
    ManageGroceries.enter self, db
  end

  def enter_manage_categories_sub(db)
    puts "not yet implemented :("
  end

  def enter_manage_shops_sub(db)
    puts "not yet implemented :("
  end

  def enter_import_shopping_data(db)
    puts "not yet implemented :("
  end

end
