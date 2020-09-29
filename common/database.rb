require 'sqlite3'

DB_FILE = 'grocerynoceros.db'.freeze

class Database

  @db = nil

  def connect
    unless defined? @db
      @db = SQLite3::Database.open DB_FILE
    end
  end

  def ddl(stmt)
    @db.execute stmt
  end

  def has_version_table
    !(@db.get_first_row "SELECT name FROM sqlite_master WHERE type='table' AND name='version_history'").nil?
  end

  def has_applied(filename)
    !(@db.get_first_row 'SELECT filename FROM version_history WHERE filename=?', filename).nil?
  end

  def apply(filename)
    @db.execute "INSERT INTO version_history (filename, created_at) VALUES (?, datetime('now'))", filename
  end

  def disconnect
    @db.close
  end

end
