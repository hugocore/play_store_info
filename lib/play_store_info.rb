module PlayStoreInfo
  store_link 'https://play.google.com/store/apps/details?id=com.your.app&hl=en'.freeze

  attr_accessor :url, :id, :inspector

  def read(url)
    @url = url
    @id = @url.match(/id=([[:alnum:]\.]+)[&]?/)

    raise InvalidStoreLink, "URL should look like '#{store_link}'" unless google_store? && @id

    @id = @id[1]
  end

  def parse
    @address = @url

    @inspector ||= MetaInspector.new(url)

    {
      id: @id,
      name: read_app_name,
      icon_url: read_logo_url,
      description: read_description
    }
  end

  private

  def google_store?
    @url.match(%r{\Ahttps://play.google.com}).any?
  end

  def read_app_name
    name = inspector.parsed.xpath('//div[@class="document-title"]/div/text()').text

    raise AppNotFound, "App not found at '#{@url}'" unless name

    name = name.split('-').first

    name.strip
  end

  def read_logo_url
    inspector.parsed.xpath('//img[@class="cover-image"]/@src').first.try(:value) || ''
  end

  def read_description
    inspector.parsed.xpath('//div[@itemprop="description"]').first.inner_html.strip
  end
end
