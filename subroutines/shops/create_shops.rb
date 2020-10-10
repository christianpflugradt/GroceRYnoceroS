require_relative '../../common/flow'

module CreateShops
  extend self, Flow

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
    print_usage_text @hint
    shop = input 'input shop'
    until shop.empty?
      if db.shop_exists?(0, shop)
        print_nack "Shop '#{shop}' already exists."
      else
        db.insert_shop(shop)
        print_ack "Shop '#{shop}' created."
      end
      shop = input 'input shop'
    end

  end

end
