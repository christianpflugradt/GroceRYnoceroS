module SqlShop

  def shop_exists?(shop_name)
    (@db.get_first_row('SELECT COUNT(id) FROM shops WHERE name = ?', shop_name)[0]).positive?
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

  def select_shops(filter)
    @db.query 'SELECT id, name FROM shops WHERE name LIKE ? ORDER BY name LIMIT 99', "#{filter}%"
  end

end
