require 'json'
require 'opening_hours'

Story.destroy_all
Spati.destroy_all
User.destroy_all

# User anlegen
User.create!(name: "Harry Styles", email: "harry@styles.com", password: "123456" )
User.create!(name: "Taylor Swift", email: "taylor@swift.com", password: "123456")
User.create!(name: "Angela Merkel", email: "angela@merkel.de", password: "123456")
User.create!(name: "Brigitte Bardott", email: "brigitte@bardott.com", password: "123456")
User.create!(name: "Max Raabe", email: "max@raabe.com", password: "123456")

# Öffnungszeiten-Formatierungsmethode
def format_opening_time(raw_hours)
  return "24/7" if raw_hours&.strip == "24/7"
  return "keine Angabe" if raw_hours.blank?

  begin
    oh = OpeningHours::Hours.new(raw_hours)
    %w[Mo Tu We Th Fr Sa Su].map do |day|
      tag = {
        "Mo" => "Mo",
        "Tu" => "Di",
        "We" => "Mi",
        "Th" => "Do",
        "Fr" => "Fr",
        "Sa" => "Sa",
        "Su" => "So"
      }[day]

      ranges = oh.opening_hours_for(day.downcase)
      if ranges.empty?
        "#{tag}: geschlossen"
      else
        times = ranges.map do |r|
          from = r[:from].strftime("%H")
          to   = r[:to].strftime("%H")
          "#{from}–#{to}"
        end
        "#{tag}: #{times.join(', ')}"
      end
    end.join("\n")
  rescue
    "keine Angabe"
  end
end

# JSON-Datei laden
file_path = File.join(Rails.root, 'db', 'allspatis.json')
file = File.read(file_path)
data = JSON.parse(file)

# Bilder einsammeln
images = Dir[Rails.root.join('app', 'assets', 'images', '*.jpeg')]

# Spätis erzeugen
data["elements"].each do |element|
  name = element["name"] || "Späti Späti"

  address = [
    element["addr:street"],
    element["addr:housenumber"],
    element["addr:postcode"],
    element["addr:city"]
  ].compact.join(' ')

  lon = element["lon"]
  lat = element["lat"]

  # Öffnungszeiten direkt übernehmen
  opening_time = element["opening_hours"] || "keine Angabe"

  spati = Spati.create!(
    name: name,
    address: address,
    opening_time: opening_time,
    longitude: lon,
    latitude: lat
  )

  random_image = images.sample
  file = File.open(random_image)
  spati.photos.attach(io: file, filename: "spati.jpeg", content_type: "image/jpeg")
  file.close

  content = element["spatistory"]
  Story.create(content: content, spati: spati, user: User.all.sample)
end

