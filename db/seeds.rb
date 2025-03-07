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
images = Dir[Rails.root.join('app', 'assets', 'images', '*.jpeg')]
# images = ["app/assets/images/spati_1.jpeg", "spati_2", "spati_3", "spati_4", "spati_5", "spati_6", "spati_7","spati_8"]
data["elements"].each do |element|
  # next unless element["tags"] && element["tags"]["shop"] == "convenience"

  name = element["name"] || "Späti Späti"
  address = [
    element["addr:street"],
    element["addr:housenumber"],
    element["addr:postcode"],
    element["addr:city"]
  ].compact.join(' ')
  lon = element["lon"]
  lat = element["lat"]
  timing = element["opening_hours"]
  spati = Spati.create!(name: name, address: address, opening_time: timing, longitude: lon, latitude: lat)
  random_images = images.sample
  p random_images
    file = File.open(random_images)
    spati.photos.attach(io: file, filename: "spati.jpeg", content_type: "image/jpeg")
    file.close

  spati.save!
  content = element["spatistory"]
  Story.create(content: content, spati: spati, user: User.all.sample)
end
# s.each_with_index do |path, index|
