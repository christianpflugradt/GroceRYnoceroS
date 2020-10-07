require_relative '../../common/script'

module CreateShops
  extend self, Script

  @hint = <<HINT

  ------------------
  [Create Shops]

  Input a shop and press enter to confirm.
  Continue adding shops and confirm each by pressing enter.
  When you are done just press enter to return to the previous menu.
      
  Once you are done adding shops you can review them all
  and rename or delete those that you input incorrectly.
  You will then also be able to link them to categories. 
  --------------------------------------------------------

HINT

  def run(db)
    puts @hint
    shop = input 'input shop'
    until shop.empty?
      db.shop_exists?(shop) ?
          print_error("Shop '#{shop}' already exists.") :
          db.insert_shop(shop)
      shop = input 'input shop'
    end

  end

end
