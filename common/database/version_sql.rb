module SqlVersion
  extend self

  def version_table?
    !(@db.get_first_row "SELECT name FROM sqlite_master WHERE type='table' AND name='version_history'").nil?
  end

  def applied?(filename)
    !(@db.get_first_row 'SELECT filename FROM version_history WHERE filename=?', filename).nil?
  end

  def apply(filename)
    @db.execute "INSERT INTO version_history (filename, created_at) VALUES (?, datetime('now'))", filename
  end

end
