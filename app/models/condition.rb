require './app/models/trip'
require 'pry'

class Condition < ActiveRecord::Base

  def self.get_paginated_conditions(params)
    self.order(:date).paginate(:page => params[:page], :per_page => 30)
  end

  # Analytics for temperature ranges
  def self.sort_temp(range)
    array = where(max_temperature: range).all.map {|condition| condition.date}
    trip_nums = array.map do |date|
      Trip.where(start_date: date.beginning_of_day...date.end_of_day).count
    end
    output = {}
    output[:max] = trip_nums.sort.last
    output[:min] = trip_nums.sort.reverse.last
    output[:avg] = trip_nums.inject(:+) / trip_nums.length unless trip_nums.length == 0
    output
  end

  def self.sort_precip(range)
    array = where(precipitation: range).all.map {|condition| condition.date}
    trip_nums = array.map do |date|
      Trip.where(start_date: date.beginning_of_day...date.end_of_day).count
    end
    output = {}
    output[:max] = trip_nums.sort.last
    output[:min] = trip_nums.sort.reverse.last
    output[:avg] = trip_nums.inject(:+) / trip_nums.length unless trip_nums.length == 0
    output
  end

  def self.sort_wind(range)
    array = Condition.where(mean_wind_speed: range).all.map {|condition| condition.date}
    trip_nums = array.map do |date|
      Trip.where(start_date: date.beginning_of_day...date.end_of_day).count
    end
    output = {}
    output[:max] = trip_nums.sort.last
    output[:min] = trip_nums.sort.first
    output[:avg] = trip_nums.inject(:+) / trip_nums.length unless trip_nums.length == 0
    output
  end

  def self.sort_sight(range)
    array = Condition.where(mean_visibility: range).all.map {|condition| condition.date}
    trip_nums = array.map do |date|
      Trip.where(start_date: date.beginning_of_day...date.end_of_day).count
    end
    output = {}
    output[:max] = trip_nums.sort.last
    output[:min] = trip_nums.sort.first
    output[:avg] = trip_nums.inject(:+) / trip_nums.length unless trip_nums.length == 0
    output
  end

  def self.condition_on_day_with_highest_rides
    day_with_highest_rides = Trip.day_with_highest_rides
    Condition.find_by(date: day_with_highest_rides)
  end

  def self.condition_on_day_with_lowest_rides
    day_with_lowest_rides = Trip.day_with_lowest_rides
    Condition.find_by(date: day_with_lowest_rides)
  end

  def self.average_rides_per_temperature_range(degrees)
    days = Condition.days_with_high_temps(degrees)
    ride_count = Trip.total_trip_count_on_dates(days)
    average_number_of_rides(ride_count, days)
  end

  def self.highest_rides_per_temperature_range(degrees)
    days = Condition.days_with_high_temps(degrees)
    Trip.max_trip_count_by_dates(days)
  end

  def self.lowest_rides_per_temperature_range(degrees)
    days = Condition.days_with_high_temps(degrees)
    Trip.min_trip_count_by_dates(days)
  end

  def self.average_number_of_rides(ride_count, days)
    ride_count / days.length
  end

  def self.days_with_high_temps(degrees = 10)
    conditions_in_a_temperature_range = where(max_temperature: [degrees..degrees + 9])
    conditions_in_a_temperature_range.map { |condition| condition.date }
  end

  # Analytics for precipitation increments
  def self.average_rides_per_precipitation_increment(inch)
    days = Condition.days_by_precipitation_increments(inch)
    ride_count = Trip.total_trip_count_on_dates(days)
    average_number_of_rides(ride_count, days)
  end

  def self.highest_rides_per_precipitation_increment(inch)
    days = Condition.days_by_precipitation_increments(inch)
    Trip.max_trip_count_by_dates(days)
  end

  def self.lowest_rides_per_precipitation_increment(inch)
    days = Condition.days_by_precipitation_increments(inch)
    Trip.min_trip_count_by_dates(days)
  end

  def self.days_by_precipitation_increments(inch)
    conditions_in_a_precipitation_range = Condition.where(precipitation: [inch..inch + 0.49])
    conditions_in_a_precipitation_range.map { |condition| condition.date }
  end

  # Analytics for wind speed increments
  def self.average_rides_per_wind_speed_increment(speed)
    days = Condition.days_by_wind_speed_increments(speed)
    ride_count = Trip.total_trip_count_on_dates(days)
    average_number_of_rides(ride_count, days)
  end

  def self.highest_rides_per_wind_speed_increment(speed)
    days = Condition.days_by_wind_speed_increments(speed)
    Trip.max_trip_count_by_dates(days)
  end

  def self.lowest_rides_per_wind_speed_increment(speed)
    days = Condition.days_by_wind_speed_increments(speed)
    Trip.min_trip_count_by_dates(days)
  end

  def self.days_by_wind_speed_increments(speed)
    conditions_in_a_wind_speed_range = Condition.where(mean_wind_speed: [speed..speed + 3])
    conditions_in_a_wind_speed_range.map { |condition| condition.date }
  end

  # Analytics for four mile visibility increments
  def self.average_rides_per_visibility_in_four_mile_increments(mile)
    days = Condition.days_by_visibility_in_four_mile_increments(mile)
    ride_count = Trip.total_trip_count_on_dates(days)
    average_number_of_rides(ride_count, days)
  end

  def self.highest_rides_per_visibility_in_four_mile_increments(mile)
    days = Condition.days_by_visibility_in_four_mile_increments(mile)
    Trip.max_trip_count_by_dates(days)
  end

  def self.lowest_rides_per_visibility_in_four_mile_increments(mile)
    days = Condition.days_by_visibility_in_four_mile_increments(mile)
    Trip.min_trip_count_by_dates(days)
  end

  def self.days_by_visibility_in_four_mile_increments(mile)
    conditions_in_a_visibility_range = Condition.where(mean_visibility: [mile..mile + 3])
    conditions_in_a_visibility_range.map { |condition| condition.date }
  end
end
