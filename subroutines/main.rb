require_relative '../common/menu'
require_relative '../common/inout'
require_relative 'groceries/manage_groceries'
require_relative 'categories/manage_categories'
require_relative 'shops/manage_shops'

module Main
  extend self, Menu

  @main = true
  @subroutines = %i[
    enter_create_list_sub
    enter_manage_items_sub
    enter_manage_categories_sub
    enter_manage_shops_sub
    enter_import_shopping_data
  ]

  @menu = <<MENU

  [Main]

  (1) [tbd] create shopping list
  (2) manage groceries
  (3) manage categories
  (4) manage shops
  (5) [tbd] import data
  (6) quit GroceRYinoceroS

MENU

  def enter_create_list_sub(db)
    stdout 'not yet implemented :('
  end

  def enter_manage_items_sub(db)
    ManageGroceries.enter self, db
  end

  def enter_manage_categories_sub(db)
    ManageCategories.enter self, db
  end

  def enter_manage_shops_sub(db)
    ManageShops.enter self, db
  end

  def enter_import_shopping_data(db)
    stdout 'not yet implemented :('
  end

end
