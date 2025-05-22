require 'nokogiri'
require 'open-uri'
require 'pry'

puts "Chargement de la page CoinMarketCap"
url = 'https://coinmarketcap.com/all/views/all/' #page à scrapper
html_content = URI.open(url).read          
doc = Nokogiri::HTML(html_content)   # analyse le HTML avec Nokogiri
puts "Page chargée"

puts "Extraction des données"

crypto_array = []

doc.xpath('//table//tbody/tr').each do |row|

  begin
    symbol_element = row.at_xpath('./td[2]/div/a[2]')&.text&.strip || "N/A"
    price_element_text = row.at_xpath('./td[5]/div/span')&.text&.strip || "N/A"
    
    price = if price_element_text == "N/A"
              "N/A"
            else
              price_element_text.gsub(/[^\d\.]/, '').to_f
            end

   crypto_array << { symbol_element => price }
   puts "#{symbol_element} : #{price} USD"       
  rescue => e
    crypto_array << { "N/A" => "N/A" }
  end
end
 
# puts " #{symbol} : #{price} USD"
  
# puts "\n Résultat final : #{crypto_array.size} cryptos récupérées"