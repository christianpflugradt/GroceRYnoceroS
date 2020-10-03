require_relative '../../common/script'

module CreateGroceries
  extend self, Script

  @hint = <<HINT

    [Create Groceries]

    Input a grocery and press enter to confirm.
    Continue adding groceries and confirm each by pressing enter.
    When you are done just press enter to return to the previous menu.
      
    Once you are done adding groceries you can review them all
    and rename or delete those that you input incorrectly.
    You will then also be able to assign them to categories. 

HINT

  def run(db)
    puts @hint
    inp = input 'input grocery'
    until inp.empty?
      db.insert_grocery inp
      inp = input 'input grocery'
    end

  end

end
