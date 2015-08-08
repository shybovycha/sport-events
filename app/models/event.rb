class Event < ActiveRecord::Base
  SPORTS = [
    'cycling',
    'running',
    'baseball',
    'soccer',
    'basketball',
    'fitness',
    'workout'
  ]

  has_and_belongs_to_many :users

  geocoded_by :address, latitude: :lat, longitude: :lng
  reverse_geocoded_by :lat, :lng, address: :address, lookup: :google

  after_validation :reverse_geocode
  after_validation :geocode
end
