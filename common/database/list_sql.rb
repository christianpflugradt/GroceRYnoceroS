module SqlList

  def create_single_shop_list(shop_id)
    insert_into_lists = <<SQL
      INSERT INTO lists (name, created_at) VALUES ('single list ' || datetime('now'), datetime('now') )
SQL
    insert_into_shops = <<SQL
      INSERT INTO shops_in_lists (list_id, shop_id, created_at) VALUES (?, ?, datetime('now'))
SQL
    @db.execute insert_into_lists
    list_id = (@db.get_first_row('SELECT MAX(id) FROM lists'))[0]
    @db.execute insert_into_shops, shop_id, list_id
    list_id
  end

  def add_groceries_to_list(list_id, grocery_ids)
    unless grocery_ids.empty?
      sql = "INSERT INTO groceries_in_lists (list_id, grocery_id, created_at) VALUES (?, ?, datetime('now'))"
      grocery_ids.each do |grocery_id|
        @db.execute sql, list_id, grocery_id
      end
    end
  end

  def view_shopping_list(id)
    @db.query 'SELECT grocery_id, grocery, category FROM shopping_list_view WHERE list_id = ?', id
  end

  def remove_from_list(list_id, grocery_ids)
    unless grocery_ids.empty?
      in_clause = grocery_ids.map(&:to_s).join(',').to_s
      @db.execute <<SQL
        DELETE FROM groceries_in_lists
        WHERE list_id = #{list_id} 
        AND grocery_id IN (#{in_clause})
SQL
    end
  end

end
