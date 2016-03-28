require 'spec_helper'

describe AppParser do
  let(:name) { '<div itemprop="name"><div>Bob</div></div>' }
  let(:app_name) { Nokogiri::HTML(name) }
  let(:app_detail) { Nokogiri::HTML('<div itemprop="name"><div>Bob - The best app</div></div>') }
  let(:app_description) { Nokogiri::HTML(name + '<div itemprop="description">Yolo</div>') }
  let(:app_icon) { Nokogiri::HTML(name + '<img itemprop="image" src="//icon.png">') }

  describe '#new' do
    it 'creates an app parser' do
      parser = described_class.new('com.my.app', '<html></html>')

      expect(parser.instance_variable_get(:@id)).to eq('com.my.app')
      expect(parser.instance_variable_get(:@body)).to eq('<html></html>')
    end
  end

  describe '#to_hash' do
    it 'scrapes the app name' do
      parser = described_class.new('id', app_name)

      expect(parser.parse.name).to eq('Bob')
    end

    it 'scrapes the first part of the name if there is some description in the title' do
      parser = described_class.new('id', app_detail)

      expect(parser.parse.name).to eq('Bob')
    end

    it 'scrapes the app description' do
      parser = described_class.new('id', app_description)

      expect(parser.parse.description).to eq('Yolo')
    end

    it "scrapes the app's icon url" do
      parser = described_class.new('id', app_icon)

      expect(parser.parse.icon_url).to eq('http://icon.png')
    end
  end

  describe '#parse' do
    it 'scrapes the app name' do
      parser = described_class.new('id', app_name)

      expect(parser.parse.name).to eq('Bob')
    end

    it 'scrapes the first part of the name if there is some description in the title' do
      parser = described_class.new('id', app_detail)

      expect(parser.parse.name).to eq('Bob')
    end

    it 'scrapes the app description' do
      parser = described_class.new('id', app_description)

      expect(parser.parse.description).to eq('Yolo')
    end

    it "scrapes the app's icon url" do
      parser = described_class.new('id', app_icon)

      expect(parser.parse.icon_url).to eq('http://icon.png')
    end
  end
end
