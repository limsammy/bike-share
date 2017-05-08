require 'pry'
class Station < ActiveRecord::Base
  validates :name, :dock_count, :city_id, :date, presence: true
  belongs_to :city

  def self.total
    Station.all.count
  end

  def self.average_bikes
    Station.average(:dock_count).round
  end

  # Should we be returning the entire station obj or just the dock_count/name field?
  def self.most_bikes
    Station.order('dock_count DESC').first
  end

  # Station objects or names?
  def self.top_stations(amount)
    Station.order('dock_count DESC').limit(amount)
  end

  def self.lowest_station(amount)
    Station.order('dock_count ASC').limit(amount)
  end

  def self.most_recent
    Station.order('date ASC').first
  end

  def self.oldest
    Station.order('date DESC').first
  end
end
