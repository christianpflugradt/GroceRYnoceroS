module SqlGrocery

  def insert_grocery(grocery)
    @db.execute "INSERT INTO groceries (name, created_at) VALUES (?, datetime('now'))", grocery
  end

end
