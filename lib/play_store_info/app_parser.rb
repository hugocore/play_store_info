require 'play_store_info/readers'

module PlayStoreInfo
  class AppParser
    include PlayStoreInfo::Readers

    readers %w(id name artwork description current_rating rating_count genre_names url price author)

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
      name = @body.xpath('//h1[@itemprop="name"]').text

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

    def read_current_rating
      current_rating = @body.xpath('//meta[@itemprop="ratingValue/@content"]').first&.value&.strip || ''
      current_rating.nil? ? '' : current_rating.strip
    end

    def read_rating_count
      rating_count = @body.xpath('//meta[@itemprop="ratingCount/@content"]').first&.value&.strip || ''
      rating_count.nil? ? '' : rating_count.split(",").join().strip
    end

    def read_genre_names
      genre_names = []
      @body.xpath('//a[@itemprop="genre"]').each do |tag|
        genre_names << tag.text
      end
      genre_names
    end

    def read_url
      url = @body.xpath('//a[@class="dev-link"]/@href').first&.value&.strip || ''
      url.match(%r{^https?:\/\/}).nil? ? "http://#{url.gsub(%r{\A\/\/}, '')}" : url
    end

    def read_price
      price = @body.xpath('//meta[@itemprop="price"]/@content').first&.value&.strip || ''
      price.nil? ? '' : price.strip
    end

    def read_author
      author = @body.xpath('//div[contains(text(), "Offered By")]/following-sibling::div').text()
      author.nil? ? '' : author.strip
    end

  end
end
