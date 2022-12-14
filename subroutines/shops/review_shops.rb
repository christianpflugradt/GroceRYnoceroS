require_relative '../../common/inout'
require_relative '../../common/flow'

module ReviewShops
  extend self, Flow

  class Shop < Flow::Item
  end

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
    update_selection db
    delete_shops db unless @selection.empty?
    if @selection.empty?
      print_nack "You don't have any shops in your database."
    else
      rename_shops db
    end
  end

  def delete_shops(db)
    print_list @selection
    print_usage_text @hint_delete
    ids = input_ids max_id(@selection), 'delete these shops'
    unless ids.empty?
      db.delete_shops(ids.map { |index| find_by_index(index, @selection).id })
      print_ack "#{ids.length} shops have been deleted."
      update_selection db
    end
  end

  def rename_shops(db)
    print_list @selection
    print_usage_text @hint_rename
    ids = input_ids max_id(@selection), 'rename these shops'
    ids.each { |index| rename_shop db, index }
  end

  def rename_shop(db, index)
    shop = find_by_index index, @selection
    new_name = input "enter new name for '#{shop.name}'"
    if new_name.empty?
      print_nack "Shop '#{shop.name}' not renamed because of empty input."
    elsif db.shop_exists? shop.id, new_name
      print_nack "Shop '#{shop.name}' not renamed because shop '#{new_name}' already exists."
    else
      db.rename_shop shop.id, new_name
      print_ack "Shop '#{shop.name}' renamed to '#{new_name}'."
    end
  end

  def update_selection(db)
    load_items db.select_all_shops, @selection, Shop
  end

end
