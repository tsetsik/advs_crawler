require 'curb'

class SelogerAdapter < BaseAdapter
  URL = 'http://www.seloger.com/list.htm?ci=590328,590482,590636'.freeze

  def proccess
    page = noko_parse(visit_page)
    Array.new(total_pages(page)) do |p|
      page = noko_parse(visit_page((p + 1))) if p > 0
      page_advs(page)
    end
  end

  private

  def query_params
    { idtt:         2,
      idtypebien:   '13,14,2,4',
      pxmax:        '450000',
      pxmin:        '125000',
      tri:        'a_px',
      ci:           '590328,590482,590636' }
  end

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
      link: adv.css('div.listing_photo_container a').attr('href'),
      img: adv.css('div.listing_photo_container img').attr('src'),
      title: adv.css('div.listing_infos h2 a').attr('title'),
      price: adv.css('a.amount').text.gsub(/<\/?[^>]*>/, ''),
      description: adv.css('p.description').text }
  end

  def visit_page(page_num = 1)
    visit(url: URL, query_params: query_params.merge(pg: page_num))
  end
end
