module SqlCategory

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
    @db.execute 'UPDATE categories SET name = ? WHERE id = ?', new_name, id
  end

  def select_categories(filter)
    @db.query 'SELECT id, name FROM categories WHERE name LIKE ? ORDER BY name LIMIT 99', "#{filter}%"
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
