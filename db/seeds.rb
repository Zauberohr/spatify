require 'json'

Story.destroy_all
Spati.destroy_all
User.destroy_all


  User.create!(name: "Harry Styles", email: "harry@styles.com", password: "123456" )
  User.create!(name: "Taylor Swift", email: "taylor@swift.com", password: "123456")
  User.create!(name: "Angela Merkel", email: "angela@merkel.de", password: "123456")
  User.create!(name: "Brigitte Bardott", email: "brigitte@bardott.com", password: "123456")
  User.create!(name: "Max Raabe", email: "max@raabe.com", password: "123456" )


file_path = File.join(Rails.root, 'db', 'allspatis.json')
file = File.read(file_path)
data = JSON.parse(file)

data["elements"].each do |element|
  # next unless element["tags"] && element["tags"]["shop"] == "convenience"

  name = element["name"] || "Unbekannt"
  address = [
    element["addr:street"],
    element["addr:housenumber"],
    element["addr:postcode"],
    element["addr:city"]
  ].compact.join(' ')
  lon = element["lon"]
  lat = element["lat"]

  content = element["spatistory"]

  spati = Spati.create!(name: name, address: address, longitude: lon, latitude: lat)
  Story.create(content: content, spati: spati, user: User.all.sample)
end
