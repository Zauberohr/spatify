class Spati < ApplicationRecord
  # Geocoding
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  # Assoziationen
  has_many :stories
  has_many_attached :photos

  # Virtuelles Attribut für Formular
  attr_accessor :always_open

  # Methode: Ist der Späti gerade offen?
  def open_now?
    return true if opening_time == "24/7"
    return false if opening_time.blank?

    now = Time.zone.now
    current_day = now.strftime("%a")
    day_map = {
      "Mon" => "Mo",
      "Tue" => "Di",
      "Wed" => "Mi",
      "Thu" => "Do",
      "Fri" => "Fr",
      "Sat" => "Sa",
      "Sun" => "So"
    }

    today = day_map[current_day]
    yesterday = day_map[(now - 1.day).strftime("%a")]

    today_entry = opening_time.split("; ").find { |line| line.start_with?(today + ":") }
    yesterday_entry = opening_time.split("; ").find { |line| line.start_with?(yesterday + ":") }

    # Prüfe heutigen Eintrag
    return true if time_range_open?(today_entry, now)

    # Prüfe Nachlauf vom Vortag (z. B. Do: 22–02 → Fr 01:00 noch offen)
    return true if time_range_open?(yesterday_entry, now, from_yesterday: true)

    false
  end

  private

  def time_range_open?(entry, current_time, from_yesterday: false)
    return false unless entry

    time_str = entry.split(": ")[1].to_s.strip

    from_str, to_str = if time_str.include?("–")
      time_str.split("–")
    elsif time_str.include?("-")
      time_str.split("-")
    elsif time_str.include?("bis")
      time_str.split("bis")
    else
      return false
    end

    begin
      from_time = normalize_time(from_str)
      to_time = normalize_time(to_str)

      from = Time.zone.parse(from_time)
      to = Time.zone.parse(to_time)

      if to < from
        # Zeitspanne geht über Mitternacht
        to += 1.day
        from -= 1.day if from_yesterday
        current_time.between?(from, to)
      else
        current_time.between?(from, to)
      end
    rescue
      false
    end
  end

  def normalize_time(raw)
    raw = raw.strip
    parts = raw.split(":")
    if parts.length == 2
      "%02d:%02d" % [parts[0].to_i, parts[1].to_i]
    else
      hour = raw.gsub(/\D/, "").to_i
      "%02d:00" % hour
    end
  end
end
