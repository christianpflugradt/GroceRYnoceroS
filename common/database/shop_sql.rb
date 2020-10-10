module SqlShop

  def shop_exists?(id, shop_name)
    (@db.get_first_row('SELECT COUNT(id) FROM shops WHERE name = ? AND id <> ?', shop_name, id)[0]).positive?
  end

  def insert_shop(shop)
    @db.execute "INSERT INTO shops (name, created_at) VALUES (?, datetime('now'))", shop.strip
  end

  def delete_shops(ids)
    @db.execute "DELETE FROM shops WHERE id IN (#{ids.map(&:to_s).join(',')})" unless ids.empty?
  end

  def rename_shop(id, new_name)
    @db.execute "UPDATE shops SET name = ?, updated_at = datetime('now') WHERE id = ?", new_name, id
  end

  def select_all_shops
    @db.query 'SELECT id, name FROM shops ORDER BY name'
  end

  def select_categories_in_shop_by_priority(id)
    sql = <<SQL
      SELECT c.id, c.name FROM categories c 
      INNER JOIN categories_in_shops cs
      ON c.id = cs.category_id
      WHERE cs.shop_id = ?
      ORDER BY cs.priority
SQL
    @db.query sql, id
  end

  def select_categories_in_shop(id)
    @db.query <<SQL
      SELECT id, name FROM categories 
      WHERE id IN (
        SELECT category_id FROM categories_in_shops 
        WHERE shop_id = #{id})
      ORDER BY name
SQL
  end

  def select_categories_not_in_shop(id)
    @db.query <<SQL
      SELECT id, name FROM categories 
      WHERE id NOT IN (
        SELECT category_id FROM categories_in_shops 
        WHERE shop_id = #{id})
      ORDER BY name
SQL
  end

  def select_max_category_priority_for_shop(id)
    @db.get_first_row('SELECT COALESCE(MAX(priority), 0) FROM categories_in_shops WHERE shop_id = ?', id)[0]
  end

  def add_categories_to_shop(category_ids, shop_id, min_priority)
    unless category_ids.empty?
      priority = min_priority
      sql = <<SQL
        INSERT INTO categories_in_shops 
        (shop_id, category_id, priority, created_at) 
        VALUES (?, ?, ?, datetime('now'))
SQL
      category_ids.each do |category_id|
        @db.execute sql, shop_id, category_id, priority
        priority += 1
      end
    end
  end

  def remove_categories_from_shop(shop_id, ids)
    unless ids.empty?
      in_clause = ids.map(&:to_s).join(',').to_s
      @db.execute <<SQL
        DELETE FROM categories_in_shops
        WHERE shop_id = #{shop_id} 
        AND category_id IN (#{in_clause})
SQL
    end
  end

  def fix_category_priorities_for_shop(id)
    updates = []
    sql_result = select_categories_in_shop_by_priority id
    begin
      sql_result.each_with_index do |row, index|
        sql = <<SQL
          UPDATE categories_in_shops
          SET priority = #{index + 1}, updated_at = datetime('now')
          WHERE shop_id = #{id} AND category_id = #{row[0]}
SQL
        updates.append sql
      end
    ensure
      sql_result.close
    end
    updates.each { |sql| @db.execute sql }
  end

end
