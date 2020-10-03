module Script

  def enter(caller, db)
    run db
    caller&.print_menu
  end

end
