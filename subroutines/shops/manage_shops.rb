require_relative 'create_shops'
require_relative 'review_shops'
require_relative 'add_categories_to_shops'
require_relative 'adjust_category_priorities_for_shop'
require_relative 'remove_categories_from_shops'
require_relative '../../common/inout'

module ManageShops
  extend self, Menu

  @subroutines = %i[
    enter_create_shops_sub
    enter_add_categories_sub
    enter_adjust_category_priorities_sub
    enter_remove_categories_sub
    enter_review_shops_sub
  ]

  @menu = <<MENU

  [Manage Shops]

  (1) create new shops
  (2) add categories to shops
  (3) adjust category priorities for shops
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

  def enter_adjust_category_priorities_sub(db)
    AdjustCategoryPrioritiesForShop.enter self, db
  end

  def enter_remove_categories_sub(db)
    RemoveCategoriesFromShops.enter self, db
  end

  def enter_review_shops_sub(db)
    ReviewShops.enter self, db
  end

end
