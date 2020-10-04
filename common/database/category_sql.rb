module SqlCategory

  def insert_category(category)
    @db.execute "INSERT INTO categories (name, created_at) VALUES (?, datetime('now'))", category.strip
  end

  def delete_categories(ids)
    @db.execute "DELETE FROM categories WHERE id IN (#{ids.map(&:to_s).join(',')})"
  end

  def rename_categories(id, new_name)
    @db.execute 'UPDATE categories SET name = ? WHERE id = ?', new_name, id
  end

  def select_all_categories
    @db.query 'SELECT id, name FROM categories'
  end

end
