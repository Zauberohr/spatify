class Spati < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_many :stories
  has_many_attached :photos
end
