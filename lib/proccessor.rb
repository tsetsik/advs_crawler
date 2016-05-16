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
    notify_sender if proccess_adapters.length > 0
  end

  private

  def proccess_adapters
    addvs = @adapters.inject({}) do |buffer, adapter|
      buffer.merge(adapter.class => adapter.proccess.flatten)
    end

    @diff_watcher.new(addvs).call
    []
  end

  def notify_sender
    changed
    notify_observers(@to_notify)
  end
end
