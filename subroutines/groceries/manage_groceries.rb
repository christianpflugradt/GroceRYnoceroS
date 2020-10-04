require_relative 'create_groceries'
require_relative 'assign_groceries'
require_relative 'review_groceries'

module ManageGroceries
  extend self, Menu

  @subroutines = %i[
    enter_create_groceries_sub
    enter_assign_groceries_sub
    enter_review_groceries_sub
  ]

  @menu = <<MENU

  [Manage Groceries]

  (1) create new groceries
  (2) assign groceries to categories
  (3) view, rename or delete groceries
  (4) return to previous menu

MENU

  def enter_create_groceries_sub(db)
    CreateGroceries.enter self, db
  end

  def enter_assign_groceries_sub(db)
    AssignGroceries.enter self, db
  end

  def enter_review_groceries_sub(db)
    ReviewGroceries.enter self, db
  end

end
