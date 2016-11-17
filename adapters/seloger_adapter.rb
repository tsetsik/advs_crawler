class SelogerAdapter < BaseAdapter
  URL = 'http://www.seloger.com/list.htm?ci=590328,590482,590636'.freeze

  def proccess
    searches.map do |search|
      @query_params = search
      page = noko_parse(visit_page)

      Array.new(total_pages(page)) do |p|
        page = noko_parse(visit_page((p + 1))) if p > 0
        page_advs(page)
      end
    end
  end

  private

  attr_reader :query_params

  def total_pages(page)
    p = page.css('p.pagination_result_number')
    return 0 if p.empty?

    p.first.text.strip.match(/(\d+)$/)[1].to_i
  end

  def page_advs(page)
    page.css('section.liste_resultat article').map do |adv|
      adv_info(adv)
    end
  end

  def adv_info(adv)
    { id: adv.attr('data-listing-id'),
      site: 'seloger.com',
      link: adv.css('div.listing_photo_container a').attr('href').value,
      img: adv.css('div.listing_photo_container img').attr('src').value,
      title: adv.css('div.listing_infos h2 a').attr('title').value,
      price: adv.css('a.amount').text.gsub(/<\/?[^>]*>/, ''),
      description: adv.css('p.description').text }
  end

  def visit_page(page_num = 1)
    visit(url: URL, query_params: query_params.merge(pg: page_num))
  end
end
