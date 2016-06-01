class Notifier
  def initialize(proccessor, mail_settings)
    @mail_settings = mail_settings
    proccessor.add_observer(self)
  end

  def update(advs)
    NotifyMailer.new(@mail_settings, advs.flatten).deliver
  end
end
