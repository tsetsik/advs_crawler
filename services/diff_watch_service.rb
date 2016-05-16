class DiffWatchService
  def initialize(addvs, db = Sqlite.new('estate_crawler.db'))
    @addvs = addvs
    @db = db
  end

  def call
    @addvs.map do |adapter, addvs|
      addvs.select { |addv| check_addv(adapter, addv) }
    end
  end

  private

  attr_reader :db

  def check_addv(adapter, addv)
    db_addv = db.find_addv(adapter, addv[:id])
    puts "\n\n #{db_addv} - db_addv \n\n"
    exit
    false
  end
end
