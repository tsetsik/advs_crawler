require 'webshot'

class BaseAdapter
  include HttpHelper
  include NokogiriHelper
  include WebshotHelper

  def initialize(searches = [])
    fail "You have to specify searches for adapter: #{self.class.name}" if searches.empty?
    @searches = searches
  end

  private

  attr_reader :searches
end
