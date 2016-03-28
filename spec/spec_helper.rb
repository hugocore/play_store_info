$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'vcr'
require 'faraday'
require 'webmock/rspec'
require 'play_store_info'

include PlayStoreInfo

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end
