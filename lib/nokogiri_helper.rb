require 'nokogiri'

module NokogiriHelper
  def noko_parse(page)
    page_body = page.respond_to?(:body) ? page.body : page
    Nokogiri::HTML(page_body)
  end
end
