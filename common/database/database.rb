require 'sqlite3'

require_relative 'category_sql'
require_relative 'grocery_sql'
require_relative 'list_sql'
require_relative 'shop_sql'
require_relative 'version_sql'

DB_FILE = 'grocerynoceros.db'.freeze

class Database
  include SqlVersion
  include SqlCategory
  include SqlGrocery
  include SqlList
  include SqlShop

  @db = nil

  def connect
    @db = SQLite3::Database.open DB_FILE unless defined? @db
  end

  def ddl(stmt)
    @db.execute stmt
  end

  def disconnect
    @db.close
  end

end
