class DiffWatchService
  def initialize(addvs, db = Sqlite.new('estate_crawler.db'))
    @addvs = addvs
    @db = db
  end

  def call
    @addvs.map do |adapter, addvs|
      addvs.select { |addv| addv_changed?(adapter, addv) }
    end
  end

  private

  attr_reader :db

  def addv_changed?(adapter, addv)
    db_addv = db.find_addv(adapter, addv[:id])
    return false if db_addv.present? && !price_changed?(db_addv, addv)

    save_change(adapter, db_addv)
    exit
    true
  end

  def save_change(adapter, db_addv)
    return db.update_addv(adapter, db_addv) if db_addv.present?
    db.update_addv(adapter, db_addv)
  end

  def price_changed?(db_addv, addv)
    fail('Missing addvartisment to check for price') unless db_addv || addv

    db_addv.symbolize_keys[:price] != addv.symbolize_keys[:price]
  end
end
