require 'nokogiri'
require 'open-uri'
require 'pry'

url = 'https://lannuaire.service-public.fr/navigation/mairie'


def get_townhall_urls
  index_url = 'https://lannuaire.service-public.fr/navigation/mairie'
  html_content = URI.open(index_url).read
  doc = Nokogiri::HTML(html_content)


  doc.xpath('//*[@id[starts-with(., "result_")]]/div/div/p/a').map do |link|
    absolute_url = URI.join(index_url, link['href']).to_s
    absolute_url 
  end
end



def get_townhall_emails(urls)
  results = []

  urls.each do |url|
    begin
      html_content = URI.open(url).read
      doc = Nokogiri::HTML(html_content)

      
      city_name = doc.at_xpath('//*[@id="titlePage"]')&.text&.strip || "Nom inconnu"

      
      email_element = doc.at_xpath('//*[@id="contentContactEmail"]/span[2]/a') 
      email = email_element ? email_element['href'].sub('mailto:', '') : "Email non trouvé" 

      results << { city_name => email }
      # puts "#{city_name} : #{email}"
    rescue => e
      puts "Erreur sur #{url} : #{e.message}"
      results << { "Erreur" => "N/A" }
    end
  end

  results
end


townhall_urls = get_townhall_urls
emails = get_townhall_emails(townhall_urls)
puts emails