require_relative 'create_categories'

module ManageCategories
  extend self, Menu

  @subroutines = %i[
    enter_create_categories_sub
    enter_review_categories_sub
  ]

  @menu = <<MENU

  [Manage Categories]

  (1) create new categories
  (2) view, rename or delete categories
  (3) return to previous menu

MENU

  def enter_create_categories_sub(db)
    CreateCategories.enter self, db
  end

  def enter_review_categories_sub(db)
    puts "not yet implemented :("
  end

end
