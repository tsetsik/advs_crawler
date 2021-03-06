require 'httparty'

module HttpHelper
  def visit(url:, query_params:)
    uri = build_uri(url: url, query_params: query_params)
    HTTParty.get(block_given? ? yield(uri) : uri, headers: req_headers)
  end

  private

  def req_headers
    {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/10.0.1 Safari/600.7.12',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Language' => 'en-US,en;q=0.8',
      'Accept-Encoding' => 'gzip, deflate, sdch',
      'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
      'Keep-Alive'  => '115',
      'Connection'  => 'keep-alive'
    }
  end

  def build_uri(url:, query_params:)
    uri = URI(url)
    uri.query = URI.encode_www_form(query_params)
    block_given? ? yield(uri) : uri
  end
end
