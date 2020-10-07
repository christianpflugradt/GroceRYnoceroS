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
    category = input 'input category'
    until category.empty?
      db.category_exists?(category) ?
          print_error("Category '#{category}' already exists.") :
          db.insert_category(category)
      category = input 'input category'
    end

  end

end
