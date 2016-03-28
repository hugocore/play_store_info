require 'metainspector'

module PlayStoreInfo
  MIN_REGEXP_MATCHES = 2.freeze
  FIRST_REGEXP_MATCH = 1.freeze

  def self.read(url)
    id = url.match(/id=([[:alnum:]\.]+)[&]?/)

    raise InvalidStoreLink unless google_store?(url) && id && id.length == MIN_REGEXP_MATCHES

    parse(id[FIRST_REGEXP_MATCH], url)
  end

  private

  def parse(id, url)
    inspector ||= MetaInspector.new(url)

    {
      id: id,
      name: read_app_name(inspector),
      icon_url: read_logo_url(inspector),
      description: read_description(inspector)
    }
  end

  def google_store?(url)
    url.match(%r{\Ahttps://play.google.com})
  end

  def read_app_name(inspector)
    name = inspector.parsed.xpath('//div[@class="document-title"]/div/text()').text

    raise AppNotFound if name.empty?

    name.split('-').first
  end

  def read_logo_url(inspector)
    inspector.parsed.xpath('//img[@class="cover-image"]/@src').first&.value || ''
  end

  def read_description(inspector)
    inspector.parsed.xpath('//div[@itemprop="description"]').first&.inner_html
  end

  class GenericError < StandardError; end

  class InvalidStoreLink < GenericError
    def initialize
      store_link = 'https://play.google.com/store/apps/details?id=com.your.app&hl=en'.freeze

      super "URL should look like '#{store_link}'"
    end
  end

  class AppNotFound < GenericError
    def initialize
      super 'Could not find app in Google Play Store'
    end
  end
end
