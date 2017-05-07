require_relative '../spec_helper'
require 'time'
require './app/models/station'

RSpec.describe Station, :type => :model do

  date = Time.parse("08/06/2013")
  describe "creating a station with attributes" do
    it "requires name, dock_count, city, and date attributes" do
      valid_station = Station.create(name: "stationicus",
                                     dock_count: 42,
                                     city: "Denver",
                                     date: date)
      expect(valid_station).to be_valid

      no_name_station = Station.create(dock_count: 42,
                                       city: "Denver",
                                       date: date)
      expect(no_name_station).not_to be_valid

      no_dock_count_station = Station.create(name: "stationicus",
                                             city: "Denver",
                                             date: date)
      expect(no_dock_count_station).not_to be_valid

      no_city_station = Station.create(name: "stationicus",
                                       dock_count: 42,
                                       date: date)
      expect(no_city_station).not_to be_valid

      no_date_station = Station.create(name: "stationicus",
                                       dock_count: 42,
                                       city: "Denver")
      expect(no_date_station).not_to be_valid
    end
  end
end
