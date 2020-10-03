require_relative '../../common/inout'
require_relative '../../common/script'

module ReviewGroceries
  extend self, Script

  class Grocery
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  @hint_filter = <<HINT_FIL

    [Review Groceries]
    
    A maximum of 99 groceries will be displayed.
    You can input a name filter to display only groceries that start with the letters in the filter.
    For example input the letter M to only match groceries such as Milk or Mushrooms.
    Or input the letters 'Sal' to only match groceries such as Salad, Salsa or Salmon.

    Just press enter if you don't want to apply a filter.

HINT_FIL

  @hint_delete = <<HINT_DEL

    [Delete Groceries]

    Next to each grocery listed above is a number.
    If you want to delete any of the groceries listed, input their numbers separated by comma.
    For example enter '1,4,23' to permanently delete the groceries numbered 1, 4 and 23.

    Just press enter if you don't want to delete any of these groceries.
  
HINT_DEL

  @hint_rename = <<HINT_REN

    [Rename Groceries]

    Please note that the numbers may have changed if you deleted any groceries in the previous step.

    If you want to rename any of the groceries listed, input their numbers separated by comma.
    For example enter '1,4,23' to rename the groceries numbered 1, 4 and 23.

    Just press enter if you don't want to rename any of these groceries.

HINT_REN

  @selection = []

  def run(db)
    puts @hint_filter
    filter = input 'input a filter'
    update_selection db, filter
    unless @selection.empty?
      delete_groceries db, filter
    end
    if @selection.empty?
      puts filter.empty? ?
        "\nYou don't have any groceries in your database." :
        "\nThere are no groceries matching your filter."
    else
      rename_groceries db
    end
    puts @hint_rename
  end

  def delete_groceries(db, filter)
    print_selection
    puts @hint_delete
    ids = input_ids 'delete these groceries'
    unless ids.empty?
      db.delete_groceries(ids.map { |index| find_grocery_by_index(index).id })
      update_selection db, filter
    end
  end

  def rename_groceries(db)
    print_selection
    puts @hint_rename
    ids = input_ids 'rename these groceries'
    ids.each { |index| rename_grocery db, index }
  end

  def rename_grocery(db, index)
    grocery = find_grocery_by_index index
    new_name = input "enter new name for '#{grocery.name}'"
    if new_name.empty?
      puts 'grocery not renamed'
    else
      db.rename_grocery grocery.id, new_name
      puts 'grocery renamed'
    end
  end

  def find_grocery_by_index(id)
    @selection.find { |grocery| grocery.index == id }
  end

  def print_selection
    puts "\n----------"
    @selection.each { |grocery| puts "(#{grocery.index})\t#{grocery.name}" }
  end

  def update_selection(db, filter)
    @selection.clear
    sql_result = db.select_groceries filter
    begin
      sql_result.each_with_index do |row, index|
        @selection.append Grocery.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

end
