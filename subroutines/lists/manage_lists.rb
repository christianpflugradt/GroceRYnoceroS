module ManageLists
  extend self, Menu

  @subroutines = %i[
    enter_create_single_list_sub
    enter_create_multi_list_sub
    enter_load_list_sub
    enter_delete_list_sub
  ]

  @menu = <<MENU

  [Manage Lists]

  (1) [tbd] create single shop list
  (2) [tbd] create multi shop list
  (3) [tbd] load existing list
  (4) [tbd] delete existing list
  (5) return to previous menu

MENU

  def enter_create_single_list_sub(db)
    stdout 'not yet implemented :('
  end

  def enter_create_multi_list_sub(db)
    stdout 'not yet implemented :('
  end

  def enter_load_list_sub(db)
    stdout 'not yet implemented :('
  end

  def enter_delete_list_sub(db)
    stdout 'not yet implemented :('
  end

end
