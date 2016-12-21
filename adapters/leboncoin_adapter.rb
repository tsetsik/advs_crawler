class LeboncoinAdapter < BaseAdapter
  URL = 'https://www.leboncoin.fr/ventes_immobilieres/offres/nord_pas_de_calais/nord/'.freeze

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
    p = page.css('div.pagination_links_container')
    return 0 if p.empty?

    p.css('a#last').attr('href').value.match(/o=(\d+)/)[1].to_i
  end

  def page_advs(page)
    page.css('section.tabsContent ul li').map do |adv|
      adv_info(adv)
    end
  end

  def adv_info(adv)
    link = adv.css('a')
    { id: link.attr('href').value.match(%r{\/(\d+).htm})[1],
      site: 'leboncoin.fr',
      link: "http:#{link.attr('href').value}",
      title: link.attr('title').value,
      img: adv_img(adv),
      price: link.css('h3.item_price').text,
      description: adv_location(adv) }
  end

  def adv_img(adv)
    "http:#{adv.css('a').css('span.lazyload').attr('data-imgsrc')}"
  rescue NoMethodError
    'https://static.leboncoin.fr/img/no-picture.png'
  end

  def adv_location(adv)
    adv.css('p.item_supp')[1]
      .text
      .strip
      .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      .gsub(/\s+/, '')
  end

  def visit_page(page_num = 1)
    visit(url: URL, query_params: query_params.merge(o: page_num)) do |uri|
      uri.tap do |u|
        u.query = u.query.gsub('%2B', '+').gsub('%C3%BB', '%FB').gsub('%C3%A9', '%E9')
        u.query << '&ret=1&ret=3'
      end
    end
  end
end
