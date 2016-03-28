module PlayStoreInfo
  class AppParser
    def initialize(id, body)
      @id = id
      @body = body
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
      name = @body.xpath('//div[@itemprop="name"]/div/text()').text

      raise AppNotFound if name.empty?

      name.split(' - ').first.strip # get the proper name if the app name contains some description
    end

    def read_logo_url
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
