require 'mail'
require 'slim'

class BaseNotifier < Mail::Message
  def initialize(mail_settings, recipients = nil)
    @settings = mail_settings.deep_symbolize_keys

    set_mail_settings
    super do
      from @settings.fetch(:smtp_settings).fetch(:from).to_s
      to Array(recipients).join(',') if recipients.present?
      self.subject = subject

      self.text_part = output_text
      self.html_part = output_html
    end
  end

  private

  def subject
    fail NotImplementedError
  end

  def output_text
    fail NotImplementedError
  end

  def output_html
    fail NotImplementedError
  end

  def render(tmpl)
    tmpl_file = "#{File.dirname(__FILE__)}/templates/#{tmpl}.slim"
    Slim::Template.new(tmpl_file, {}).render(self)
  end

  def set_mail_settings
    delivery_method = @settings.fetch(:delivery_method)

    case delivery_method
    when 'smtp'
      smtp_info = @settings.fetch(:smtp_settings).except(:from)
      Mail.defaults { delivery_method(:smtp, smtp_info) }
    when 'sendmail'
      Mail.defaults { delivery_method(:sendmail) }
    else
      fail(NotImplementedError, 'Not implemented mail method')
    end
  end
end
