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
    @db.execute 'UPDATE shops SET name = ? WHERE id = ?', new_name, id
  end

  def select_all_shops
    @db.query 'SELECT id, name FROM shops ORDER BY name'
  end

  def select_categories_not_in_shop(id)
    @db.query <<SQL
      SELECT id, name FROM categories 
      WHERE id NOT IN (
        SELECT category_id FROM categories_in_shops 
        WHERE shop_id = #{id})
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

end
