require 'observer'

class Proccessor
  include Observable

  def initialize
    @adapters = []
    @to_notify = []
  end

  def add_adapter(adapter)
    @adapters << adapter
  end

  def run
    notify_sender if proccess_adapters.length > 0
  end

  private

  def proccess_adapters
    @adapters.each do |a|
      @to_notify += a.proccess
    end
    @to_notify
  end

  def notify_sender
    changed
    notify_observers(@to_notify)
  end
end
