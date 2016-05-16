require 'sqlite3'

class Sqlite
  def initialize(db_name)
    @db = SQLite3::Database.new(db_name)
    # Create tables if don't exists
    init_tables
  end

  def find_addv(adapter, id, fields = '*')
    db.results_as_hash = true
    db.execute("SELECT #{fields} FROM addvs WHERE adapter = ? AND id = ?", [adapter.to_s, id.to_s])
  end

  private

  attr_reader :db

  def init_tables
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS addvs (
        id int,
        adapter varchar(30),
        title varchar(80),
        img varchar(100),
        price varchar(30),
        description varchar(255)
      );
    SQL
  end
end
