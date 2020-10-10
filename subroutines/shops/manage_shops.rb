require_relative 'create_shops'
require_relative 'review_shops'
require_relative 'add_categories_to_shops'
require_relative 'remove_categories_from_shops'
require_relative '../../common/inout'

module ManageShops
  extend self, Menu

  @subroutines = %i[
    enter_create_shops_sub
    enter_add_categories_sub
    enter_set_category_order_sub
    enter_remove_categories_sub
    enter_review_shops_sub
  ]

  @menu = <<MENU

  [Manage Shops]

  (1) create new shops
  (2) add categories to shops
  (3) [tbd] set order of categories for shops
  (4) remove categories from shops
  (5) view, rename or delete shops
  (6) return to previous menu

MENU

  def enter_create_shops_sub(db)
    CreateShops.enter self, db
  end

  def enter_add_categories_sub(db)
    AddCategoriesToShops.enter self, db
  end

  def enter_set_category_order_sub(db)
    stdout 'not yet implemented :('
  end

  def enter_remove_categories_sub(db)
    RemoveCategoriesFromShops.enter self, db
  end

  def enter_review_shops_sub(db)
    ReviewShops.enter self, db
  end

end
