require 'sqlite3'

DB_FILE = '../grocerynoceros.db'

class Database

  @db = nil

  def connect
    unless defined? @db
      @db = SQLite3::Database.open DB_FILE
    end
  end

  def disconnect
    @db.close
  end

end