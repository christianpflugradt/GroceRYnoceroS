module SqlGrocery

  def insert_grocery(grocery)
    @db.execute "INSERT INTO groceries (name, created_at) VALUES (?, datetime('now'))", grocery
  end

  def delete_groceries(ids)
    @db.execute "DELETE FROM groceries WHERE id IN (#{ids.map(&:to_s).join(',')})"
  end

  def rename_grocery(id, new_name)
    @db.execute 'UPDATE groceries SET name = ? WHERE id = ?', new_name, id
  end

  def select_groceries(filter)
    @db.query 'SELECT id, name FROM groceries WHERE name like ?', "#{filter}%"
  end

end
