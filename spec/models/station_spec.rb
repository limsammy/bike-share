require_relative '../spec_helper'
require 'time'

RSpec.describe Station, :type => :model do
  describe "creating a station with attributes" do
    before(:each) do
      @city = City.create(name: 'Denver')
    end

    it "requires name, dock_count, city, and date attributes" do
      valid_station = Station.create(name: "stationicus",
                                     dock_count: 42,
                                     city_id: @city.id,
                                     date: '12/16/1997')
      expect(valid_station).to be_valid

      no_name_station = Station.create(dock_count: 42,
                                       city_id: @city.id,
                                       date: '12/16/1997')
      expect(no_name_station).not_to be_valid

      no_dock_count_station = Station.create(name: "stationicus",
                                             city_id: @city.id,
                                             date: '12/16/1997')
      expect(no_dock_count_station).not_to be_valid

      no_city_station = Station.create(name: "stationicus",
                                       dock_count: 42,
                                       date: '12/16/1997')
      expect(no_city_station).not_to be_valid

      no_date_station = Station.create(name: "stationicus",
                                       dock_count: 42,
                                       city_id: @city.id)
      expect(no_date_station).not_to be_valid
    end
  end

  describe "calculating station statistics" do
    before(:each) do
      @city = City.create(name: Faker::Address.unique.city)
    end
    it "returns the total count of all stations" do
      50.times do
        Station.create(name: Faker::Name.unique.name,
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      end
      expect(Station.total).to be(50)
    end

    it "returns the average amount of bikes per station based on dock_count" do
      Station.create(name: Faker::Name.unique.name,
                       dock_count: 11,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      Station.create(name: Faker::Name.unique.name,
                       dock_count: 3,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      Station.create(name: Faker::Name.unique.name,
                       dock_count: 22,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      expect(Station.average_bikes).to be(12)
    end

    it "returns the station with most bikes" do
      Station.create(name: Faker::Name.unique.name,
                       dock_count: 11,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      Station.create(name: Faker::Name.unique.name,
                       dock_count: 3,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      Station.create(name: "Big Ol' Station",
                       dock_count: 22,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      expect(Station.most_bikes[:dock_count]).to be(22)
      expect(Station.most_bikes[:name]).to eq("Big Ol' Station")
    end

    it "returns top x stations based on dock_count" do
      50.times do
        Station.create(name: Faker::Name.unique.name,
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      end
      expect(Station.top_stations(10).all.count).to eq(10)
    end

    it "returns lowest station based on dock_count" do
      Station.create(name: 'No Bikes Station',
                       dock_count: 0,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      50.times do
        Station.create(name: Faker::Name.unique.name,
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      end
            binding.pry
      expect(Station.lowest_station(1).first[:name]).to eq('No Bikes Station')
    end

    it "returns MULTIPLE stations based on low dock_count" do
      Station.create(name: 'No Bikes Station',
                       dock_count: 0,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      Station.create(name: 'No Bikes Here',
                       dock_count: 1,
                       city_id: @city.id,
                       date: Faker::Date.backward(500))
      expect(Station.lowest_station(5).all.count).to eq(2)
      expect(Station.lowest_station(5).first[:name]).to eq('No Bikes Station')
      expect(Station.lowest_station(5)[1][:name]).to eq('No Bikes Here')
    end

    it "returns the most recently installed station" do
      Station.create(name: Faker::Name.unique.name,
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: Faker::Date.backward(100))
      Station.create(name: 'New Station!',
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: 5/6/2017)
      Station.create(name: Faker::Name.unique.name,
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: Faker::Date.backward(100))
      expect(Station.most_recent[:name]).to eq('New Station!')
    end

    it "returns the oldest station" do
      Station.create(name: 'blah blah',
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: '12/16/1997')
      Station.create!(name: 'Old Station!',
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: '5/6/1900')
      Station.create(name: 'TEST',
                       dock_count: rand(100),
                       city_id: @city.id,
                       date: '4/7/2005')
      # binding.pry
      expect(Station.oldest[:name]).to eq('Old Station!')
    end
  end

  describe "station relationships" do
    before(:each) do
      @city = City.create(name: Faker::Address.unique.city)
    end
    it "belongs to a city" do
      station = Station.create(name: "stationicus",
                               dock_count: 42,
                               city_id: @city.id,
                               date: '12/16/1997')
      expect(station.city.id).to eq(@city.id)
    end
  end
end
