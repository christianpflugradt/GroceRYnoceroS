require_relative '../common/menu'
require_relative '../common/inout'
require_relative 'categories/manage_categories'
require_relative 'groceries/manage_groceries'
require_relative 'lists/manage_lists'
require_relative 'shops/manage_shops'

module Main
  extend self, Menu

  @subroutines = %i[
    enter_manage_lists_sub
    enter_manage_groceries_sub
    enter_manage_categories_sub
    enter_manage_shops_sub
    enter_import_data
  ]

  @menu = <<MENU

  [Main]

  (1) manage lists
  (2) manage groceries
  (3) manage categories
  (4) manage shops
  (5) [tbd] import data
  (6) quit GroceRYinoceroS

MENU

  def enter_manage_lists_sub(db)
    ManageLists.enter self, db
  end

  def enter_manage_groceries_sub(db)
    ManageGroceries.enter self, db
  end

  def enter_manage_categories_sub(db)
    ManageCategories.enter self, db
  end

  def enter_manage_shops_sub(db)
    ManageShops.enter self, db
  end

  def enter_import_data(db)
    stdout 'not yet implemented :('
  end

end
