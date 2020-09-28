require_relative 'inout'

module Menu

  def enter(caller, db)
    inp = nil
    until inp == @subroutines.length + 1
      (inp and (0..@subroutines.length) === inp) ? (send @subroutines[inp - 1], db) : (print_menu)
      inp = input_num
    end
    if caller then caller.print_menu end
  end

  def print_menu
    puts @menu
    puts <<HINT
  Enter a number 1-#{@subroutines.length + 1} and hit 'Enter' to choose a menu point

HINT
  end

end