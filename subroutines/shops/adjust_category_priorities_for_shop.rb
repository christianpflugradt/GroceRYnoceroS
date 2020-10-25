require_relative '../../common/inout'
require_relative '../../common/flow'

module AdjustCategoryPrioritiesForShop
  extend self, Flow

  class Category < Flow::Item
    attr_writer :index
  end

  class Shop < Flow::Item
  end

  @hint_shop = <<HINT_SHOP

  -----------------
  [Choose Shop]

  Next to each shop listed above is a number.

  Input the number of the shop you want to adjust category priorities for
  You can only update one shop at a time. Do not enter multiple numbers.

  Just press enter to return to the previous menu without adjusting category priorities.
  --------------------------------------------------------------------------------------

HINT_SHOP

  @hint_cat = <<HINT_CAT
  ----------------------------
  [Adjust Category Priorities]

  Next to each category listed above is a number.

  You can adjust the priority of one category at a time.
  Input the number of the category you want to adjust followed by a slash
  and the number next to the position you want to move it to.
  
  This will decrease the priority of the category at the target position by one.
  All categories between the original and new position of the adjusted category
  will have their priorities adjusted as well.

  An example:

  (1) A
  (2) B
  (3) C
  (4) D
  
  We want to move D to 2nd position, so we input: 4/2
  This will update the priorities to:

  (1) A
  (2) D
  (3) B
  (4) C

  To move a category to the end of the list enter one more than the number of the last position.
  The following input will move A to the end of the list after C: 1/5

  The list will be updated after each action but this hint will not be shown again.

  To keep the changes you made and return to the previous menu just press enter.
  ------------------------------------------------------------------------------

HINT_CAT

  @shops = []
  @categories = []

  def run(db)
    @changed = false
    load_shops db
    print_list @shops
    print_usage_text @hint_shop
    if @shops.empty?
      print_nack "You don't have any shops in your database."
    else
      select_shop_and_adjust db
    end
  end

  def select_shop_and_adjust(db)
    shop = find_by_index(input_num('adjust for this shop'), @shops)
    if shop.nil?
      print_nack 'Shop number is invalid.'
    else
      load_categories db, shop.id
      if @categories.empty?
        print_nack "Shop '#{shop.name}' does not have any categories added."
      else
        adjust_for_shop db, shop
      end
    end
  end

  def adjust_for_shop(db, shop)
    print_list @categories
    print_usage_text @hint_cat
    loop do
      choice = read_choice
      while !choice.empty? && (pos = extract_positions(choice)).nil?
        print_nack 'Enter a valid command or just press enter to return to previous menu.'
        choice = read_choice
      end
      break if choice.empty?
      do_adjust pos[0], pos[1]
    end
    if @changed
      persist_adjusted_priorities db, shop.id
      print_ack "Changes to '#{shop.name}' have been saved."
    else
      print_ack 'No changes have been made.'
    end
  end

  def read_choice
    input 'input category and target position'
  end

  def extract_positions(choice)
    invalid = nil
    pos = choice.split('/').map(&:to_i)
    if pos.length == 2
      (1..(@categories.length + 1)).include?(pos[0]) && (1..(@categories.length + 1)).include?(pos[1]) ? pos : invalid
    else
      invalid
    end
  end

  def do_adjust(source, target)
    unless ((target - 1)..target).include? source
      @categories.insert(target - 1, @categories[source - 1])
      @categories.delete_at(source < target ? source - 1 : source)
      @categories.each_with_index do |category, index|
        category.index = index + 1
      end
      @changed = true
    end
    print_list @categories
  end

  def persist_adjusted_priorities(db, shop_id)
    @categories.each_with_index do |category, index|
      db.update_category_priority_for_shop shop_id, category.id, index
    end
  end

  def load_shops(db)
    @shops.clear
    sql_result = db.select_all_shops
    begin
      sql_result.each_with_index do |row, index|
        @shops.append Shop.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

  def load_categories(db, id)
    @categories.clear
    sql_result = db.select_categories_in_shop_by_priority id
    begin
      sql_result.each_with_index do |row, index|
        @categories.append Category.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

end
