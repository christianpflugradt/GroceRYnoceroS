require_relative 'create_categories'
require_relative 'remove_from_category'
require_relative 'review_categories'

module ManageCategories
  extend self, Menu

  @subroutines = %i[
    enter_create_categories_sub
    enter_remove_groceries_sub
    enter_review_categories_sub
  ]

  @menu = <<MENU

  [Manage Categories]

  (1) create new categories
  (2) remove groceries from categories
  (3) view, rename or delete categories
  (4) return to previous menu

MENU

  def enter_create_categories_sub(db)
    CreateCategories.enter self, db
  end

  def enter_review_categories_sub(db)
    ReviewCategories.enter self, db
  end

  def enter_remove_groceries_sub(db)
    RemoveFromCategory.enter self, db
  end

end
