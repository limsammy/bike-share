require 'pry'

class Trip < ActiveRecord::Base
  validates :duration, :start_date, :start_station_id, :end_date, :end_station_id, :bike_id, :subscription_type, presence: true

  belongs_to :start_station, :class_name => "Station"
  belongs_to :end_station, :class_name => "Station"

  def self.get_first_30
    all_trips = Trip.order(:start_date)
    first_30_trips = []
    30.times do |number|
      first_30_trips << all_trips[number] unless all_trips[number].nil?
    end
    first_30_trips
  end

  #Trips Dashboard methods for Info

  def self.average_duration_of_a_ride
    average(:duration).to_i
  end

  def self.longest_ride
    maximum(:duration).to_i
  end

  def self.shortest_ride
    minimum(:duration).to_i
  end

  def self.station_with_most_starting_place_rides
    group(:start_station).count("id").max_by do |station, count|
      station
    end
  end

  def self.station_with_most_ending_place_rides
    group(:end_station).count("id").max_by do |station, count|
      count
    end
  end

  def self.month_by_month_breakdown_with_subtotals_by_year

  end

  def self.most_ridden_bike
    group(:bike_id).count("id").max_by do |bike, count|
      count
    end
  end

  def self.least_ridden_bike
    group(:bike_id).count("id").min_by do |bike, count|
      count
    end
  end

  def self.user_subscription_type_count
    group(:bike_id).count("id").max_by do |bike, count|
      count
    end
  end

  def self.user_subscription_type_with_percentage

  end

  def self.highest_number_of_trips
    group(:start_date).count("id").max_by do |date, count|
      count
    end
  end

  def self.lowest_number_of_trips
    group(:start_date).count("id").min_by do |date, count|
      count
    end
  end

  #Individual station methods for Info

  def self.number_of_rides_started_at_station
    where(start_station_id: id).count
  end

  def self.number_of_rides_ended_at_station
    where(end_station_id: id).count

  end

  def self.most_frequest_starting_station
    station = group(:start_station).count
    top_station = station.max_by { |station, count| count }
    #station.first.name
  end

  def self.least_frequest_starting_station
    station = group(start_station).count
    lowest_station = station.min_by
  end

  def self.highest_number_of_trips_of_stations_by_date

  end

  def self.most_frequesnt_zip_code_for_starting_station

  end

  def self.most_frequenst_bike_id_for_starting_station

  end

end
