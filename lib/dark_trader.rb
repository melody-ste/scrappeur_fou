require 'nokogiri'
require 'httparty'
require 'pry'

puts "Chargement de la page CoinMarketCap"
url = 'https://coinmarketcap.com/' #page à scrapper
response = HTTParty.get(url)          # fait une requête GET
html_content = response.body          # récupère le HTML
doc = Nokogiri::HTML(html_content)   # analyse le HTML avec Nokogiri
puts "Page chargée"


puts "Extraction des données"
crypto_rows = doc.xpath('//table//tbody/tr')
# Sélectionne tous les éléments <tr> (table row) dans <tbody> dans une <table>
# Chaque <tr> correspond à une crypto

crypto_array = []

# boucle pour extraire les données
crypto_rows.each do |row|
 
  symbol_element = row.at_xpath('.//p[contains(@class, "coin-item-symbol")]')   #//*[@id="__next"]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/thead/tr/th[3]
  
  # puts "#{symbol_element}" 

  price_element = row.at_xpath('.//td[contains(@class, "price")]//span') 

  # puts "#{price_element}" 

  # si il y a les deux infos 
  if symbol_element && price_element
    symbol = symbol_element.text.strip #récup juste le texte
    price = price_element.text.strip.gsub(/[^\d\.]/, '').to_f  # récup juste le nombre

    crypto_hash = { symbol => price.round(2) } 
    crypto_array << crypto_hash  # ajoute le hash au tableau vide dans haut

    puts " #{symbol} : #{price.round(2)} USD"
  end
end


puts "\n Résultat final : #{crypto_array.size} cryptos récupérées"
puts crypto_array