require_relative '../../common/inout'
require_relative '../../common/flow'
require_relative '../../common/list/list_service'

module RemoveGroceries
  extend self, Flow

  class ListItem
    attr_reader :id, :name, :cat, :index

    def initialize(id, name, cat, index)
      @id = id
      @name = name
      @cat = cat
      @index = index
    end
  end

  class Item
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  class Grocery < Item
  end

  class Category < Item
  end

  class Shop < Item
  end

  @hint_rem = <<HINT_REM

  ---------------------------------------
  [Remove Groceries from List]
    
  Above you see a preview of the shopping list.
  Next to each grocery on the list is a number.

  If you want to remove any of them from the list, input their numbers separated by comma.
  ----------------------------------------------------------------------------------------

HINT_REM

  def run(db)
    list_id = ListService.id
    list_items = ListService.retrieve_flat db
    print_list list_items
    print_usage_text @hint_rem
    grocery_ids = (input_ids list_items.length, 'remove from list')
                  .map { |index| find_by_index index, list_items }
                  .map(&:id)
    unless grocery_ids.empty?
      db.remove_from_list list_id, grocery_ids
      print_ack "#{grocery_ids.length} have been removed from the list."
    end
  end

  def find_by_index(id, list)
    list.find { |category| category.index == id }
  end

  def print_list(list)
    print_list_header
    list.each { |item| print_list_item item.index, item.name }
    stdout ''
  end

end
