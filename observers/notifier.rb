class Notifier
  def initialize(proccessor, mail_settings)
    @mail_settings = mail_settings
    proccessor.add_observer(self)
  end

  def update(to_notify)
    puts "\n\n #{to_notify} - to_notify \n\n"
  end
end
