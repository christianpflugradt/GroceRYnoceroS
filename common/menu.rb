require_relative 'inout'

module Menu

  def enter(caller, db)
    inp = nil
    until inp == @subroutines.length + 1
      (inp and (1..@subroutines.length) === inp) ? (send @subroutines[inp - 1], db) : (print_menu)
      inp = input_num
    end
    caller&.print_menu
  end

  def print_menu
    menu_text = respond_to?(:dynamic_menu) ? dynamic_menu : @menu
    print_menu_text menu_text
    print_menu_text <<HINT
  Enter a number 1-#{@subroutines.length + 1} and hit 'Enter' to choose a menu point

HINT
  end

end
