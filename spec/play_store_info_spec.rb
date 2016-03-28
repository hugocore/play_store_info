require 'spec_helper'

describe PlayStoreInfo do
  it 'has a version number' do
    expect(PlayStoreInfo::VERSION).not_to be nil
  end

  describe '.read' do
    it 'raises error if the URL does not follow the right format' do
      VCR.use_cassette('wrong_url') do
        expect do
          described_class.read('http://google.com')
        end.to raise_error(PlayStoreInfo::InvalidStoreLink)
      end
    end
  end

  describe '.parse' do
    it 'raises error if the URL points to an app that does not exists' do
      VCR.use_cassette('invalid_url') do
        invalid_url = 'https://play.google.com/store/apps/details?id=com.your.app&hl=en'
        expect do
          described_class.read(invalid_url)
        end.to raise_error(PlayStoreInfo::AppNotFound)
      end
    end
  end
end
