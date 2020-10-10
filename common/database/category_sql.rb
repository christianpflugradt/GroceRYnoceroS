module SqlCategory

  def category_exists?(id, category_name)
    (@db.get_first_row('SELECT COUNT(id) FROM categories WHERE name = ? AND id <> ?', category_name, id)[0]).positive?
  end

  def insert_category(category)
    @db.execute "INSERT INTO categories (name, created_at) VALUES (?, datetime('now'))", category.strip
  end

  def delete_categories(ids)
    unless ids.empty?
      in_clause = ids.map(&:to_s).join(',').to_s
      @db.execute "DELETE FROM groceries_in_categories WHERE category_id IN (#{in_clause})"
      @db.execute "DELETE FROM categories WHERE id IN (#{in_clause})"
    end
  end

  def rename_category(id, new_name)
    @db.execute "UPDATE categories SET name = ?, updated_at = datetime('now') WHERE id = ?", new_name, id
  end

  def select_all_categories
    @db.query 'SELECT id, name FROM categories ORDER BY name'
  end

  def remove_groceries_from_category(category_id, ids)
    unless ids.empty?
      in_clause = ids.map(&:to_s).join(',').to_s
      @db.execute <<SQL
        DELETE FROM groceries_in_categories 
        WHERE category_id = #{category_id} 
        AND grocery_id IN (#{in_clause})
SQL
    end
  end

end
