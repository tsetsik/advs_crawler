class Ebay < BaseAdapter
  URL = 'http://www.ebay.co.uk/sch/i.html'.freeze

  def proccess
    page = noko_parse(visit_page)

    Array.new(total_pages(page)) do |p|
      page = noko_parse(visit_page((p + 1))) if p > 0
      page_advs(page)
    end
  end

  private

  def page_advs(page)
    page.css('ul#ListViewInner li.sresult').map do |adv|
      adv_info(adv)
    end
  end

  def adv_info(adv)
    { id: adv.attr('listingid').to_s,
      site: 'ebay.co.uk',
      link: adv.css('div:first.lvpic a').attr('href').to_s,
      title: adv.css('h3.lvtitle a').text,
      img: img(adv).to_s,
      price: adv.css('ul.lvprices li.lvprice span').text,
      description: "shipping: #{adv.css('ul.lvprices li.lvshipping span').text}" }
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

  def query_params
    {
      _form: 'R40',
      _sacat: 0,
      LH_BIN: 1,
      _sop: 2,
      LH_ItemCondition: 1000,
      Network: 'Unlocked|!',
      _nkw: 'iphone 7',
      LH_PrefLoc: 3,
      _dcat: 9355,
      rt: 'nc',
      _fcid: 3,
      _ipg: 50,
      _mPrRngCbx: 1,
      _udlo: 300,
      _udhi: 650
    }
  end

  def visit_page(page_num = 1)
    visit(url: URL, query_params: query_params.merge(_pgn: page_num))
  end
end
