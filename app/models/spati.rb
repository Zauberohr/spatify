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
    return false unless opening_time.present?

    begin
      time = Time.current
      OpeningHours::Time::Fake.now = time
      OpeningHours.parse(opening_time).open?
    rescue
      false
    end
  end

end
