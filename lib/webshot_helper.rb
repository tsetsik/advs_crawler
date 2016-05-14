require 'webshot'

module WebshotHelper
  def screen(url)
    ws = ::Webshot::Screenshot.instance
    ws.capture url, "screenshots/#{self.class.name.underscore}.png", width: 700, height: 600
  end
end
