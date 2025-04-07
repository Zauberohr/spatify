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
    opening_time == "24/7"
  end
end
