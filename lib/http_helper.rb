module HttpHelper
  def visit(url:, query_params:)
    uri = build_uri(url: url, query_params: query_params)
    Net::HTTP.get_response(block_given? ? yield(uri) : uri)
  end

  private

  def build_uri(url:, query_params:)
    uri = URI(url)
    uri.query = URI.encode_www_form(query_params)
    block_given? ? yield(uri) : uri
  end
end
