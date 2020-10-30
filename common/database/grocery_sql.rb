module SqlGrocery

  def grocery_exists?(id, grocery_name)
    (@db.get_first_row('SELECT COUNT(id) FROM groceries WHERE name = ? AND id <> ?', grocery_name, id)[0]).positive?
  end

  def insert_grocery(grocery)
    @db.execute "INSERT INTO groceries (name, created_at) VALUES (?, datetime('now'))", grocery.strip
  end

  def delete_groceries(ids)
    @db.execute "DELETE FROM groceries WHERE id IN (#{ids.map(&:to_s).join(',')})" unless ids.empty?
  end

  def rename_grocery(id, new_name)
    @db.execute "UPDATE groceries SET name = ?, updated_at = datetime('now') WHERE id = ?", new_name, id
  end

  def select_groceries(filter)
    @db.query 'SELECT id, name FROM groceries WHERE name LIKE ? ORDER BY name LIMIT 99', "%#{filter}%"
  end

  def select_groceries_for_shop(shop_id, filter)
    @db.query <<SQL
      SELECT g.id, g.name FROM groceries g
      INNER JOIN groceries_in_categories gc ON g.id = gc.grocery_id
      INNER JOIN categories c ON gc.category_id = c.id
      INNER JOIN categories_in_shops cs ON c.id = cs.category_id
      WHERE cs.shop_id = #{shop_id}
      AND g.name LIKE '%#{filter}%'
      ORDER BY g.name LIMIT 99
SQL
  end

  def select_groceries_by_category(id)
    sql = <<SQL
      SELECT g.id, g.name FROM groceries g 
      INNER JOIN groceries_in_categories gc
      ON g.id = gc.grocery_id
      WHERE gc.category_id = ?
      ORDER BY g.name
SQL
    @db.query sql, id
  end

  def select_unassigned_groceries
    @db.query <<SQL
      SELECT id, name FROM groceries 
      WHERE id NOT IN (SELECT grocery_id FROM groceries_in_categories) 
      ORDER BY name LIMIT 50
SQL
  end

  def assign_groceries_to_category(grocery_ids, category_id)
    unless grocery_ids.empty?
      sql = "INSERT INTO groceries_in_categories (category_id, grocery_id, created_at) VALUES (?, ?, datetime('now'))"
      grocery_ids.each do |grocery_id|
        @db.execute sql, category_id, grocery_id
      end
    end
  end

end
