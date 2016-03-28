require 'spec_helper'

describe PlayStoreInfo do
  let(:invalid_url) { 'http://google.com' }
  let(:dummy_url) { 'https://play.google.com/store/apps/details?id=com.your.app&hl=en' }
  let(:airbnb) { 'https://play.google.com/store/apps/details?id=com.airbnb.android&hl=en' }

  it 'has a version number' do
    expect(PlayStoreInfo::VERSION).not_to be nil
  end

  describe '.read' do
    context 'something wrong' do
      it 'raises error if the URL does not follow the right format' do
        VCR.use_cassette('invalid_url') do
          expect do
            described_class.read(invalid_url)
          end.to raise_error(PlayStoreInfo::InvalidStoreLink)
        end
      end

      it 'raises error if the URL points to an app that does not exists' do
        VCR.use_cassette('dummy_url') do
          expect do
            described_class.read(dummy_url)
          end.to raise_error(PlayStoreInfo::AppNotFound)
        end
      end

      it 'raises error if the Play Store is currently offline' do
        VCR.use_cassette('offline_store') do
          # no way to distingish between having the store offline or an app that doesn't exist
          stub_request(:get, /play\.google\.com/).to_return(status: 404, body: '{}')

          expect do
            described_class.read(airbnb)
          end.to raise_error(PlayStoreInfo::AppNotFound)
        end
      end
    end

    context 'with a valid URL' do
      it 'parses the Play Store and retrieves every data' do
        VCR.use_cassette('parse_airbnb') do
          parser = described_class.read(airbnb)

          expect(parser[:id]).to eq('com.airbnb.android')
          expect(parser[:name]).to eq('Airbnb')
          expect(parser[:icon_url]).to start_with('http://lh6.ggpht.com/4jnm0-_9TBUdvNtQpefYE0T33')
          expect(parser[:description]).to start_with('Make travel planning as mobile as you are')
        end
      end
    end
  end
end
