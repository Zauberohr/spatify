require 'json'

Story.destroy_all
Spati.destroy_all
User.destroy_all

# User anlegen
User.create!(name: "Harry Styles", email: "harry@styles.com", password: "123456" )
User.create!(name: "Taylor Swift", email: "taylor@swift.com", password: "123456")
User.create!(name: "Angela Merkel", email: "angela@merkel.de", password: "123456")
User.create!(name: "Brigitte Bardott", email: "brigitte@bardott.com", password: "123456")
User.create!(name: "Max Raabe", email: "max@raabe.com", password: "123456")

# Neue Öffnungszeiten-Formatierung ohne Gem
def format_opening_time(raw_hours)
  return "24/7" if raw_hours&.strip == "24/7"
  return "keine Angabe" if raw_hours.blank?

  days = %w[Mo Tu We Th Fr Sa Su]
  full_days = {
    "Mo" => "Mo",
    "Tu" => "Di",
    "We" => "Mi",
    "Th" => "Do",
    "Fr" => "Fr",
    "Sa" => "Sa",
    "Su" => "So"
  }

  output = {}
  days.each { |day| output[day] = "❌" }

  raw_hours.split(";").each do |rule|
    day_part, time_part = rule.strip.split(" ")
    next unless day_part && time_part

    if day_part.include?("-")
      start_day, end_day = day_part.split("-")
      day_range = days[days.index(start_day)..days.index(end_day)]
    else
      day_range = [day_part]
    end

    times = time_part.split("-").map { |t| t[0, 2].to_i }

    day_range.each do |day|
      output[day] = "#{times[0]}–#{times[1]}"
    end
  end

  %w[Mo Di Mi Do Fr Sa So].map do |de_day|
    en_day = full_days.key(de_day)
    "#{de_day}: #{output[en_day]}"
  end.join("\n")
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

  # Öffnungszeiten formatieren
  opening_time = format_opening_time(element["opening_hours"])

  spati = Spati.create!(
    name: name,
    address: address,
    opening_time: opening_time,
    longitude: lon,
    latitude: lat
  )

  # Zufälliges Bild anhängen
  random_image = images.sample
  file = File.open(random_image)
  spati.photos.attach(io: file, filename: "spati.jpeg", content_type: "image/jpeg")
  file.close

  content = element["spatistory"]
  Story.create(content: content, spati: spati, user: User.all.sample)
end
