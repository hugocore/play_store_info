module PlayStoreInfo
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

  class ConnectionError < GenericError
    def initialize
      super 'Could not retrieve your app information at the moment. Please try again later.'
    end
  end
end
