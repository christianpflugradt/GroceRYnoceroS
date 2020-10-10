require_relative '../../common/flow'

module CreateGroceries
  extend self, Flow

  @hint = <<HINT

  ------------------
  [Create Groceries]

  Input a grocery and press enter to confirm.
  Continue adding groceries and confirm each by pressing enter.
  When you are done just press enter to return to the previous menu.
      
  Once you are done adding groceries you can review them all
  and rename or delete those that you input incorrectly.
  You will then also be able to assign them to categories. 
  --------------------------------------------------------

HINT

  def run(db)
    print_usage_text @hint
    grocery = input 'input grocery'
    until grocery.empty?
      if db.grocery_exists?(0, grocery)
        print_nack "Grocery '#{grocery}' already exists."
      else
        db.insert_grocery(grocery)
        print_ack "Grocery '#{grocery}' created."
      end
      grocery = input 'input grocery'
    end

  end

end
