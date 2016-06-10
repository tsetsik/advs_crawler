class DesignChangesNotifier
  def initialize(proccessor, mail_settings)
    @mail_settings = mail_settings
    proccessor.add_observer(self)
  end

  def update(adapters)
    DesignChangesNotifyMailer.new(@mail_settings, adapters).deliver
  end
end
