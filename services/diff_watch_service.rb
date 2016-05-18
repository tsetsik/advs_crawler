class DiffWatchService
  def initialize(advs, db = Sqlite.new('estate_crawler.db'))
    @advs = advs
    @db = db
  end

  def call
    @advs.map do |adapter, advs|
      advs.select { |adv| adv_changed?(adapter, adv) }
    end
  end

  private

  attr_reader :db

  def adv_changed?(adapter, adv)
    db_adv = db.find_adv(adapter, adv[:id])
    return false if db_adv.present? && !price_changed?(db_adv, adv)

    save_change(adapter, db_adv, adv)
    true
  end

  def save_change(adapter, db_adv, adv)
    return db.update_adv(adapter, db_adv) if db_adv.present?
    db.add_adv(adapter, adv)
  end

  def price_changed?(db_adv, adv)
    fail('Missing advartisment to check for price') unless db_adv || adv

    db_adv.symbolize_keys[:price] != adv.symbolize_keys[:price]
  end
end
