require 'json'

Spati.destroy_all

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
  timing = element["tags"]["opening_hours"]
  Spati.create!(name: name, address: address, opening_time: timing, longitude: lon, latitude: lat)
end
