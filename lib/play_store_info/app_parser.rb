require 'ostruct'

module PlayStoreInfo
  class AppParser
    def initialize(id, body)
      @id = id
      @body = body
    end

    def parse
      OpenStruct.new(to_hash)
    end

    def to_hash
      {
        id: @id,
        name: read_app_name,
        icon_url: read_logo_url,
        description: read_description
      }
    end

    private

    def read_app_name
      @app_name ||= begin
        name = @body.xpath('//div[@itemprop="name"]/div/text()').text

        raise AppNotFound if name.empty?

        # get the app proper name in case the title contains some description
        name.split(' - ').first.strip
      end
    end

    def read_logo_url
      @app_logo ||= begin
        url = @body.xpath('//img[@itemprop="image"]/@src').first&.value&.strip || ''

        # add the HTTP protocol if the image source is lacking http:// because it starts with //
        url.match(%r{^https?:\/\/}).nil? ? "http://#{url.gsub(%r{\A\/\/}, '')}" : url
      end
    end

    def read_description
      @app_description ||= begin
        description = @body.xpath('//div[@itemprop="description"]').first&.inner_html&.strip

        description.nil? ? '' : Sanitize.fragment(description).strip
      end
    end
  end
end
