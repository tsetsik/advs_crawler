require 'mail'
require 'slim'

class NotifyMailer < Mail::Message
  def initialize(mail_settings, advs)
    @advs = advs.flatten
    @settings = mail_settings.deep_symbolize_keys

    set_mail_defaults
    super do
      from @settings.fetch(:smtp_settings).fetch(:from).to_s
      to @settings.fetch(:emails_to_notify).join(',')
      subject 'New/Changed addvertisements for you'

      self.text_part = output_advs_text
      self.html_part = output_advs_html
    end
  end

  private

  def output_advs_text
    %(Test message da go eva)
  end

  def output_advs_html
    tmpl = "#{File.dirname(__FILE__)}/templates/html_part.slim"
    Slim::Template.new(tmpl, {}).render(self)
  end

  def set_mail_defaults
    defaults = @settings.fetch(:smtp_settings).except(:from)
    Mail.defaults do
      delivery_method(:smtp, defaults)
    end
  end
end
