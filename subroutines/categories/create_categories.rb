require_relative '../../common/flow'

module CreateCategories
  extend self, Flow

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
    print_usage_text @hint
    category = input 'input category'
    until category.empty?
      if db.category_exists?(0, category)
        print_error "Category '#{category}' already exists."
      else
        db.insert_category(category)
        print_ack "Category '#{category}' created."
      end
      category = input 'input category'
    end

  end

end
