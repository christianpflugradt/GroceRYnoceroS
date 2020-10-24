module SqlList

  def create_list(name)
    list_name_sql = name.empty? ? "'SHOPPING LIST ' || datetime('now')" : '?'
    sql = "INSERT INTO lists (name, created_at) VALUES (#{list_name_sql}, datetime('now'))"
    if name.empty?
      @db.execute sql
    else
      @db.execute sql, name
    end
    (@db.get_first_row('SELECT MAX(id) FROM lists'))[0]
  end

  def add_groceries_to_list(list_id, grocery_ids)
    unless grocery_ids.empty?
      sql = "INSERT INTO groceries_in_lists (list_id, grocery_id, created_at) VALUES (?, ?, datetime('now'))"
      grocery_ids.each do |grocery_id|
        @db.execute sql, list_id, grocery_id
      end
    end
  end

  def get_list_name(id)
    (@db.get_first_row 'SELECT name FROM lists WHERE id = ?', id)[0]
  end

  def view_shopping_list(id)
    @db.query 'SELECT grocery_id, grocery, category_id, category FROM shopping_list_view WHERE list_id = ?', id
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
