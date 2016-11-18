class EbayAdapter < BaseAdapter
  URL = 'http://www.ebay.co.uk/sch/i.html'.freeze

  def proccess
    searches.map do |search|
      @query_params = search

      page = noko_parse(visit_page(search))
      Array.new(total_pages(page)) do |p|
        page = noko_parse(visit_page((p + 1))) if p > 0
        page_advs(page).compact
      end
    end
  end

  private

  attr_reader :query_params

  def page_advs(page)
    page.css('ul#ListViewInner li.sresult').map do |adv|
      adv_info(adv) if key_in_title?(adv)
    end
  end

  def adv_info(adv)
    { id: adv.attr('listingid').to_s,
      site: 'ebay.co.uk',
      link: adv.css('div:first.lvpic a').attr('href').to_s,
      title: title(adv),
      img: img(adv).to_s,
      price: adv.css('ul.lvprices li.lvprice span').text,
      description: "shipping: #{adv.css('ul.lvprices li.lvshipping span').text}" }
  end

  def title(adv)
    adv.css('h3.lvtitle a').text
  end

  def key_in_title?(adv)
    title(adv).scan(/#{query_params[:_nkw]}/i).any?
  end

  def img(adv)
    img = adv.css('img.img')
    return unless img.present?
    img.attr('imgurl') || img.attr('src')
  end

  def total_pages(page)
    p = page.css('span.rcnt')
    (p.text.to_f / query_params[:_ipg].to_f).ceil
  end

  def visit_page(page_num = 1)
    visit(url: URL, query_params: query_params.merge(_pgn: page_num))
  end
end
