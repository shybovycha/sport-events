class Event < ActiveRecord::Base
  has_and_belongs_to_many :users

  geocoded_by :address, latitude: :lat, longitude: :lng
  after_validation :geocode
end
