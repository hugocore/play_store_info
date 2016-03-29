require 'spec_helper'

describe AppParser do
  let(:name) { '<div itemprop="name"><div>Bob</div></div>' }
  let(:app_name) { Nokogiri::HTML(name) }
  let(:app_detail) { Nokogiri::HTML('<div itemprop="name"><div>Bob - The best app</div></div>') }
  let(:app_description) { Nokogiri::HTML(name + '<div itemprop="description">Yolo</div>') }
  let(:app_icon) { Nokogiri::HTML(name + '<img itemprop="image" src="//icon.png">') }

  describe '#new' do
    it 'scrapes the app name' do
      parser = described_class.new('id', app_name)

      expect(parser.name).to eq('Bob')
    end

    it 'scrapes the first part of the name if there is some description in the title' do
      parser = described_class.new('id', app_detail)

      expect(parser.name).to eq('Bob')
    end

    it 'scrapes the app description' do
      parser = described_class.new('id', app_description)

      expect(parser.description).to eq('Yolo')
    end

    it "scrapes the app's icon url" do
      parser = described_class.new('id', app_icon)

      expect(parser.artwork).to eq('http://icon.png')
    end
  end

  describe '#to_hash' do
    it 'scrapes the app name' do
      parser = described_class.new('id', app_name)

      expect(parser.to_hash[:name]).to eq('Bob')
    end

    it 'scrapes the first part of the name if there is some description in the title' do
      parser = described_class.new('id', app_detail)

      expect(parser.to_hash[:name]).to eq('Bob')
    end

    it 'scrapes the app description' do
      parser = described_class.new('id', app_description)

      expect(parser.to_hash[:description]).to eq('Yolo')
    end

    it "scrapes the app's icon url" do
      parser = described_class.new('id', app_icon)

      expect(parser.to_hash[:artwork]).to eq('http://icon.png')
    end
  end

  describe '#to_json' do
    it 'scrapes the app name' do
      parser = described_class.new('id', app_name)

      parsed = JSON.parse(parser.to_json)

      expect(parsed['name']).to eq('Bob')
    end

    it 'scrapes the first part of the name if there is some description in the title' do
      parser = described_class.new('id', app_detail)

      parsed = JSON.parse(parser.to_json)

      expect(parsed['name']).to eq('Bob')
    end

    it 'scrapes the app description' do
      parser = described_class.new('id', app_description)

      parsed = JSON.parse(parser.to_json)

      expect(parsed['description']).to eq('Yolo')
    end

    it "scrapes the app's icon url" do
      parser = described_class.new('id', app_icon)

      parsed = JSON.parse(parser.to_json)

      expect(parsed['artwork']).to eq('http://icon.png')
    end
  end
end
