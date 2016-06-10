require 'observer'

class DiffWatchService
  include Observable

  def initialize(db = Sqlite.new('estate_crawler.db'))
    @db = db
  end

  def call(all_advs)
    check_design_changes(all_advs)

    all_advs.map do |adapter, advs|
      advs.collect { |adv| adv(adapter, adv) }.compact
    end
  end

  private

  attr_reader :db

  def check_design_changes(advs)
    empty_adapters = advs.select { |_, a| a.empty? }
    notify_design_changes(empty_adapters) if empty_adapters.length > 0
  end

  def notify_design_changes(empty_adapters)
    changed
    notify_observers(empty_adapters)
  end

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
