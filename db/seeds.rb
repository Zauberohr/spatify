require 'json'

file_path = File.join(Rails.root, 'db', 'allspatis.json')
file = File.read(file_path)
data = JSON.parse(file)

data["elements"].each do |element|
  next unless element["tags"] && element["tags"]["shop"] == "convenience"

  name = element["tags"]["name"] || "Unbekannt"
  address = [
    element["tags"]["addr:street"],
    element["tags"]["addr:housenumber"],
    element["tags"]["addr:postcode"],
    element["tags"]["addr:city"]
  ].compact.join(' ')
  lon = element["lon"]
  lat = element["lat"]
  Spati.create!(name: name, address: address, longitude: lon, latitude: lat)
end
