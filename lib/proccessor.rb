require 'observer'

class Proccessor
  include Observable

  def initialize(diff_watcher: DiffWatchService)
    @adapters = []
    @to_notify = []
    @diff_watcher = diff_watcher
  end

  def add_adapter(adapter)
    @adapters << adapter
  end

  def run
    notify_sender if proccess_adapters.flatten.length > 0
  end

  private

  def proccess_adapters
    advs = @adapters.inject({}) do |buffer, adapter|
      buffer.merge(adapter.class.to_s => adapter.proccess.flatten)
    end

    @to_notify += @diff_watcher.new(advs).call
  end

  def notify_sender
    changed
    notify_observers(@to_notify)
  end
end
