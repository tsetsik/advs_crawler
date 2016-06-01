class DiffWatchService
  def initialize(advs, db = Sqlite.new('estate_crawler.db'))
    @advs = advs
    @db = db
  end

  def call
    @advs.map do |adapter, advs|
      advs.collect { |adv| adv(adapter, adv) }.compact
    end
  end

  private

  attr_reader :db

  def adv(adapter, adv)
    db_adv = db.find_adv(adapter, adv[:id])
    return if db_adv.present? && !price_changed?(db_adv.symbolize_keys, adv.symbolize_keys)

    save_change(adapter, db_adv, adv.symbolize_keys)
  end

  def save_change(adapter, db_adv, adv)
    if db_adv.present?
      db.update_adv(adapter, adv)
      adv.merge(action: :changed_price, old_price: db_adv.symbolize_keys[:price])
    else
      db.add_adv(adapter, adv)
      adv.merge(action: :new)
    end
  end

  def price_changed?(db_adv, adv)
    fail('Missing advartisment to check for price') unless db_adv || adv
    db_adv[:price] != adv[:price]
  end
end
