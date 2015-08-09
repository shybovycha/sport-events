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

  scope :by_sports, ->(sports) { where(:sport => sports.split(',')) if sports.present? }
  scope :by_address, ->(address, radius) { near(address, radius || 20.0, units: :km) }

  scope :relevant_to, ->(query) { all.sort_by { |e| e.relevance_to query } if query.present? }

  def relevance_to(query)
    split_re = /\W+/
    query_words = query.split(split_re)

    title_words = self.title.split(split_re)
    combinations = title_words.product(query_words)
    coefficients = combinations.map { |pair| JaroWinkler.distance(pair.first, pair.last, ignore_case: true) }

    -coefficients.max
  end
end
