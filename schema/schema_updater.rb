module SchemaUpdater

  def self.update_schema(db)
    ensure_version_history db
    Dir.glob('schema/*.sql')
       .sort
       .filter { |filename| new? db, filename }
       .each do |filename|
      write_file db, filename
    end
  end

  def self.write_file(db, filename)
    file = File.open filename
    db.ddl file.read
    db.apply filename
    stdout "applied #{filename}"
  ensure
    file&.close
  end

  def self.ensure_version_history(db)
    unless db.version_table?
      db.ddl 'CREATE TABLE version_history (filename TEXT NO NULL, created_at TIMESTAMP NOT NULL)'
    end
  end

  def self.new?(db, filename)
    !db.applied? filename
  end

end
