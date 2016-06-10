class DesignChangesNotifyMailer < BaseNotifier
  def initialize(mail_settings, adapters)
    @adapters = adapters
    settings = mail_settings.deep_symbolize_keys

    super(settings, settings.fetch(:notify_design_changes))
  end

  private

  def subject
    'Deisgn changes that made some adapter return no addvs'
  end

  def output_text
    render('design_changes_text_part')
  end

  def output_html
    render('design_changes_html_part')
  end
end
