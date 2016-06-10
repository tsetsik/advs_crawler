class NotifyMailer < BaseNotifier
  def initialize(mail_settings, advs)
    @advs = advs.flatten
    settings = mail_settings.deep_symbolize_keys

    super(settings, settings.fetch(:emails_to_notify))
  end

  private

  def subject
    'New/Changed addvertisements for you'
  end

  def output_text
    render('notify_text_part')
  end

  def output_html
    render('notify_html_part')
  end
end
