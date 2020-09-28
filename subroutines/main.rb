module Main
  extend self

  @subroutines = {
      1 => :enter_create_list_sub,
      2 => :enter_manage_items_sub,
      3 => :enter_manage_categories_sub,
      4 => :enter_manage_shops_sub,
      5 => :enter_import_shopping_data
  }

  def enter(db)
    inp = nil
    until inp == @subroutines.length + 1
      subroutine = @subroutines[inp]
      subroutine ? (send subroutine, db) : (print_menu)
      inp = input_num
    end
  end

  def print_menu
    puts <<MENU

  (1) create a shopping list
  (2) manage shopping items
  (3) manage item categories
  (4) manage shops
  (5) import shopping data
  (6) quit GroceRYinoceroS

  Enter a number 1-6 and hit 'Enter' to choose a menu point

MENU
  end

  def enter_create_list_sub(db)
    puts "not yet implemented :("
  end

  def enter_manage_items_sub(db)
    puts "not yet implemented :("
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
