class LeboncoinAdapter < BaseAdapter
  URL = 'https://www.leboncoin.fr/ventes_immobilieres/offres/nord_pas_de_calais/nord/'.freeze

  def proccess
    page = noko_parse(visit_page)

    Array.new(total_pages(page)) do |p|
      page = noko_parse(visit_page((p + 1))) if p > 0
      page_addvs(page)
    end
  end

  def query_params
    { sp:       1,
      ps:       4,
      pe:       16,
      th:       1,
      location: 'Lambersart+59130,Wambrechies+59118,Quesnoy-sur-Deûle+59890' }
  end

  private

  def total_pages(page)
    p = page.css('div.pagination_links_container')
    return 0 if p.empty?

    p.css('a#last').attr('href').value.match(/o=(\d+)/)[1].to_i
  end

  def page_addvs(page)
    page.css('ul.tabsContent.dontSwitch.block-white li').map do |addv|
      addv_info(addv)
    end
  end

  def addv_info(addv)
    link = addv.css('a')
    { id: link.attr('href').value.match(%r{\/(\d+).htm})[1],
      title: link.attr('title').value,
      img: addv_img(addv),
      price: link.css('h3.item_price').text,
      description: addv_location(addv) }
  end

  def addv_img(addv)
    "http:#{addv.css('a').css('span.lazyload').attr('data-imgsrc')}"
  rescue NoMethodError
    'https://static.leboncoin.fr/img/no-picture.png'
  end

  def addv_location(addv)
    addv.css('p.item_supp')[1]
      .text
      .strip
      .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      .gsub(/\s+/, '')
  end

  def visit_page(page_num = 1)
    visit(url: URL, query_params: query_params.merge(o: page_num)) do |uri|
      uri.tap do |u|
        u.query = u.query.gsub('%2B', '+').gsub('%C3%BB', '%FB')
        u.query << '&ret=1&ret=3'
      end
    end
  end
end
