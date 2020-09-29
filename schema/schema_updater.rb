module SchemaUpdater

  def self.update_schema(db)
    ensure_version_history db
    Dir.glob('schema/*.sql')
       .sort
       .filter { |filename| is_new db, filename }
       .each do |filename|
      begin
        file = File.open filename
        db.ddl file.read
        db.apply filename
        puts "applied #{filename}"
      ensure
        file&.close
      end
    end
  end
  
  def self.ensure_version_history(db)
    unless db.has_version_table
      db.ddl 'CREATE TABLE version_history (filename TEXT NO NULL, created_at TIMESTAMP NOT NULL)'
    end
  end
  
  def self.is_new(db, filename)
    !db.has_applied filename
  end

end
