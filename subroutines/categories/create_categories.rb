require_relative '../../common/script'

module CreateCategories
  extend self, Script

  @hint = <<HINT

  -------------------
  [Create Categories]

  Input a category and press enter to confirm.
  Continue adding categories and confirm each by pressing enter.
  When you are done just press enter to return to the previous menu.
      
  Once you are done adding categories you can review them all
  and rename or delete those that you input incorrectly.
  ------------------------------------------------------

HINT

  def run(db)
    puts @hint
    inp = input 'input category'
    until inp.empty?
      db.insert_category inp
      inp = input 'input category'
    end

  end

end
