module SqlGrocery

  def insert_grocery(grocery)
    @db.execute "INSERT INTO groceries (name, created_at) VALUES (?, datetime('now'))", grocery.strip
  end

  def delete_groceries(ids)
    @db.execute "DELETE FROM groceries WHERE id IN (#{ids.map(&:to_s).join(',')})"
  end

  def rename_grocery(id, new_name)
    @db.execute 'UPDATE groceries SET name = ? WHERE id = ?', new_name, id
  end

  def select_groceries(filter)
    @db.query 'SELECT id, name FROM groceries WHERE name LIKE ? LIMIT 99', "#{filter}%"
  end

  def select_unassigned_groceries
    @db.query 'SELECT id, name FROM groceries where id NOT IN (SELECT grocery_id FROM groceries_in_categories) LIMIT 50'
  end

  def assign_groceries_to_category(grocery_ids, category_id)
    sql = "INSERT INTO groceries_in_categories (category_id, grocery_id, created_at) VALUES (?, ?, datetime('now'))"
    grocery_ids.each do |grocery_id|
      @db.execute sql, category_id, grocery_id
    end
  end

end
