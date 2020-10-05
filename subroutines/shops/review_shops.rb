require_relative '../../common/inout'
require_relative '../../common/script'

module ReviewShops
  extend self, Script

  class Shop
    attr_reader :id, :name, :index

    def initialize(id, name, index)
      @id = id
      @name = name
      @index = index
    end
  end

  @hint_filter = <<HINT_FIL

  ------------------
  [Review Shops]
  
  A maximum of 99 shops will be displayed.
  You can input a name filter to display only shops that start with the letters in the filter.
  For example input the letter R to only match shops such as Real, Rewe or Rossmann.
  Or input the letters 'Al' to only match shops such as Aldi or Alnatura.

  Just press enter if you don't want to apply a filter.
  -----------------------------------------------------

HINT_FIL

  @hint_delete = <<HINT_DEL

  ------------------
  [Delete Shops]

  Next to each shop listed above is a number.
  If you want to delete any of the shops listed, input their numbers separated by comma.
  For example enter '1,4,23' to permanently delete the shops numbered 1, 4 and 23.

  Just press enter if you don't want to delete any of these shops.
  --------------------------------------------------------------------
  
HINT_DEL

  @hint_rename = <<HINT_REN

  ------------------
  [Rename Shops]

  Please note that the numbers may have changed if you deleted any shops in the previous step.

  If you want to rename any of the shops listed, input their numbers separated by comma.
  For example enter '1,4,23' to rename the shops numbered 1, 4 and 23.

  Just press enter if you don't want to rename any of these shops.
  --------------------------------------------------------------------

HINT_REN

  @selection = []

  def run(db)
    puts @hint_filter
    filter = input 'input a filter'
    update_selection db, filter
    delete_shops db, filter unless @selection.empty?
    if @selection.empty?
      print_info filter.empty? ?
                     "You don't have any shops in your database." :
                     'There are no shops matching your filter.'
    else
      rename_shops db
    end
    puts @hint_rename
  end

  def delete_shops(db, filter)
    print_selection
    puts @hint_delete
    ids = input_ids 'delete these shops'
    unless ids.empty?
      db.delete_shops(ids.map { |index| find_shop_by_index(index).id })
      update_selection db, filter
    end
  end

  def rename_shops(db)
    print_selection
    puts @hint_rename
    ids = input_ids 'rename these shops'
    ids.each { |index| rename_shop db, index }
  end

  def rename_shop(db, index)
    shop = find_shop_by_index index
    new_name = input "enter new name for '#{shop.name}'"
    if new_name.empty?
      puts 'shop not renamed'
    else
      db.rename_shop shop.id, new_name
      puts 'shop renamed'
    end
  end

  def find_shop_by_index(id)
    @selection.find { |shop| shop.index == id }
  end

  def print_selection
    print_list_header
    @selection.each { |shop| print_list_item shop.index, shop.name }
  end

  def update_selection(db, filter)
    @selection.clear
    sql_result = db.select_shops filter
    begin
      sql_result.each_with_index do |row, index|
        @selection.append Shop.new row[0], row[1], index + 1
      end
    ensure
      sql_result.close
    end
  end

end
