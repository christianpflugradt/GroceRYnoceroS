module ManageShops
  extend self, Menu

  @subroutines = %i[
    enter_create_shops_sub
    enter_add_categories_sub
    enter_set_category_order_sub
    enter_remove_categories_sub
  ]

  @menu = <<MENU

  [Manage Shops]

  (1) create new shops
  (2) add categories to shops
  (3) set order of categories for shops
  (4) remove categories from shops
  (5) return to previous menu

MENU

  def enter_create_shops_sub(db)
    puts 'not yet implemented :('
  end

  def enter_add_categories_sub(db)
    puts 'not yet implemented :('
  end

  def enter_set_category_order_sub(db)
    puts 'not yet implemented :('
  end

  def enter_remove_categories_sub(db)
    puts 'not yet implemented :('
  end

end
