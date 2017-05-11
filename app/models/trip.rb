require 'pry'
require 'Date'

class Trip < ActiveRecord::Base

  validates :duration, :start_date, :start_station_id, :end_date, :end_station_id, :bike_id, :subscription_type, presence: true

  belongs_to :start_station, :class_name => "Station"
  belongs_to :end_station, :class_name => "Station"

  def self.get_paginated_trips(params)
    self.order(:start_date).paginate(:page => params[:page], :per_page => 30)
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
      station
    end
  end

  def self.month_by_month_breakdown
    start_year = 2013
    month = 1
    months = {}
    years= {}
    12.times do
      # binding.pry
      months[month] = where("extract(month from start_date) = ?", month).count
      month += 1
    end

    (Time.new.year - start_year).times do
      years[start_year] = where('extract(year from start_date) = ?', start_year).count
      start_year += 1
    end

    {months: months, years: years}
  end

  def self.most_ridden_bike
    group(:bike_id).order('count_id DESC').limit(1).count(:id)
  end

  def self.least_ridden_bike
    group(:bike_id).order('count_id ASC').limit(1).count(:id)
  end

  def self.user_subscription_type_count
    output = {}
    output[:customers] = where(subscription_type: "customer").count
    output[:subscribers] = where(subscription_type: "subscriber").count

    output[:customers_percentage] = ((output[:customers].to_f / count) * 100).round(2)
    output[:subscribers_percentage]  = ((output[:subscribers].to_f / count) * 100).round(2)
    output
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

  def self.number_of_rides_started_at_station(id)
    where(start_station_id: id).count
  end

  def self.number_of_rides_ended_at_station(id)
    where(end_station_id: id).count
  end

  def self.most_frequent_starting_station(id)
    station_counts = group(:start_station).count
    station_counts.max_by { |station, count| count }
  end

  def self.least_frequent_starting_station(id)
    station_counts = group(:end_station).count
    station_counts.max_by { |station, count| count }
  end

  def self.highest_number_of_trips_of_stations_by_date(id)
    date_counts = where(start_station_id: id).group(:start_date).count("id")
    date_counts.max_by { |date, count| count }
  end

  def self.lowest_number_of_trips_of_stations_by_date(id)
    date_counts = where(start_station_id: id).group(:start_date).count("id")
    date_counts.min_by { |date, count| count }
  end

  def self.most_frequent_zip_code_for_starting_station(id)
    zipcode = where(start_station_id: id).group(:zip_code).count("id")
    zipcode.max_by{|zip_code, count| count }
  end

  def self.most_frequent_bike_id_for_starting_station(id)
    bike = where(start_station_id: id).group(:bike_id).count("id")
    bike.max_by{|bike, count| count }
  end

  def self.busiest_day
    group(:start_date).count("id").max_by{|date, count| count }
  end

  def self.least_busy_day
    group(:end_date).count("id").min_by{|date, count| count }
  end

  def self.total_trip_count_on_dates(dates)
    count = 0
    dates.each do |date|
      count += Trip.where(start_date: date).length
    end
    count
  end

  def self.max_trip_count_by_dates(dates)
    trip_counts = []
    dates.each do |date|
      count = Trip.where(start_date: date).length
      trip_counts << count
    end
    trip_counts.max
  end

  def self.min_trip_count_by_dates(dates)
    trip_counts = []
    dates.each do |date|
      count = Trip.where(start_date: date).length
      trip_counts << count
    end
    trip_counts.min
  end

  def self.day_with_highest_rides
    date_and_number_of_rides = Trip.all.group(:start_date).count
    max_value = date_and_number_of_rides.max_by { |k, v| v }
    max_value[0]
  end

  def self.day_with_lowest_rides
    date_and_number_of_rides = Trip.all.group(:start_date).count
    min_value = date_and_number_of_rides.min_by { |k, v| v }
    min_value[0]
  end
end