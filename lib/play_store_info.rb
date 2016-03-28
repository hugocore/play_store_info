require 'play_store_info/errors'
require 'play_store_info/app_parser'
require 'metainspector'
require 'sanitize'

module PlayStoreInfo
  MIN_IDS_REGEXP_MATCHES = 2
  FIRST_ID_REGEXP_MATCH = 1

  def self.read(id, lang = 'en')
    parse(id, "https://play.google.com/store/apps/details?id=#{id}&hl=#{lang}")
  end

  def self.read_url(url)
    id = url.match(/id=([[:alnum:]\.]+)[&]?/)

    raise InvalidStoreLink unless google_store?(url) && id && id.length == MIN_IDS_REGEXP_MATCHES

    parse(id[FIRST_ID_REGEXP_MATCH], url)
  end

  private

  def parse(id, url)
    inspector ||= MetaInspector.new(url)

    raise AppNotFound unless inspector.response.status == 200

    AppParser.new(id, inspector.parsed).to_hash
  rescue Faraday::ConnectionFailed, Faraday::SSLError, Errno::ETIMEDOUT
    raise ConnectionError
  end

  def google_store?(url)
    url.match(%r{\Ahttps://play.google.com})
  end
end
