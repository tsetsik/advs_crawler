require 'webshot'

module WebshotHelper
  def screen(url)
    ws = ::Webshot::Screenshot.instance
    ws.capture(url, "screenshots/#{self.class.name.underscore}.png", width: 700, height: 1000)
  end

  def html(page)
    File.open("screenshots/#{self.class.name.underscore}.html", 'w') { |file| file.write(page) }
  end
end
