require_relative '../lib/mairie_christmas.rb'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'webmock'


describe '#get_townhall_urls' do
    it 'returns an array of URLs' do
      urls = get_townhall_urls
      expect(urls).to be_an(Array)
    end
  end

 describe '#get_townhall_emails' do
    it 'returns an array of hashes with city name and email' do
      urls = get_townhall_urls

      emails = get_townhall_emails(urls)
      expect(emails).to be_an(Array)
      expect(emails.first).to be_a(Hash)
      # vérifie que chaque hash a une clé et une valeur 
      emails.each do |hash|
        expect(hash.keys.first).to be_a(String)
        expect(hash.values.first).to be_a(String)
      end
    end
  end
