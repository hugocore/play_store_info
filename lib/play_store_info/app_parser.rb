require 'play_store_info/readers'
require 'ostruct'

module PlayStoreInfo
  class AppParser
    include PlayStoreInfo::Readers

    readers %w(id name artwork description)

    def initialize(id, body)
      @id = id
      @body = body

      scrape_data

      self
    end

    private

    def read_id
      @id
    end

    def read_name
      name = @body.xpath('//div[@itemprop="name"]/div/text()').text

      raise AppNotFound if name.empty?

      # get the app proper name in case the title contains some description
      name.split(' - ').first.strip
    end

    def read_artwork
      url = @body.xpath('//img[@itemprop="image"]/@src').first&.value&.strip || ''

      # add the HTTP protocol if the image source is lacking http:// because it starts with //
      url.match(%r{^https?:\/\/}).nil? ? "http://#{url.gsub(%r{\A\/\/}, '')}" : url
    end

    def read_description
      description = @body.xpath('//div[@itemprop="description"]').first&.inner_html&.strip

      description.nil? ? '' : Sanitize.fragment(description).strip
    end
  end
end
