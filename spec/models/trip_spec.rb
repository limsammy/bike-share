require_relative '../spec_helper'


RSpec.describe Trip, :type => :model do
  describe "creating a trip with attributes" do
    before(:each) do
      @city = City.create(name: "San Jose")
      @station_1 = Station.create(name: "station_1", dock_count: 32, date: "4/12/2013", city_id: @city.id)
      @station_2 = Station.create(name: "station_2", dock_count: 42, date: "6/12/2013", city_id: @city.id)
    end

    it "requires duration, start date,start station, end date, end station, bike id, subscription_type" do
      valid_trip = Trip.create(duration: "111",
                                start_date: "6/12/2015",
                                start_station_id: @station_1.id,
                                end_date: "6/13/2015",
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(valid_trip).to be_valid

      no_duration = Trip.create(
                                start_date: "6/12/2015",
                                start_station_id: @station_1.id,
                                end_date: "6/13/2015",
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(no_duration).not_to be_valid

      no_start_date = Trip.create(duration: "111",
                                  start_station_id: @station_1.id,
                                  end_date: "6/13/2015",
                                  end_station_id: @station_2.id,
                                  bike_id: 1,
                                  subscription_type: "subscriber"
                                  )
      expect(no_start_date).not_to be_valid

      no_start_station = Trip.create(duration: "111",
                                start_date: "6/12/2015",
                                end_date: "6/13/2015",
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(no_start_station).not_to be_valid

      no_end_date = Trip.create(duration: "111",
                                start_date: "6/12/2015",
                                start_station_id: @station_1.id,
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(no_end_date).not_to be_valid

      no_end_station = Trip.create(duration: "111",
                                   start_date: "6/12/2015",
                                   start_station_id: @station_1.id,
                                   end_date: "6/13/2015",
                                   bike_id: 1,
                                   subscription_type: "subscriber"
                                   )
      expect(no_end_station).not_to be_valid

      no_bike = Trip.create(duration: "111",
                            start_date: "6/12/2015",
                            start_station_id: @station_1.id,
                            end_date: "6/13/2015",
                            end_station_id: @station_2.id,
                            subscription_type: "subscriber"
                            )
      expect(no_bike).not_to be_valid

      no_subscription_type = Trip.create(duration: "111",
                                         start_date: "6/12/2015",
                                         start_station_id: @station_1.id,
                                         end_date: "6/13/2015",
                                         end_station_id: @station_2.id,
                                         bike_id: 1,
                                         )
      expect(no_subscription_type).not_to be_valid
    end
  end

  describe "trip relationships" do
    before(:each) do
      @station_1 = Station.create(name: "station_1", dock_count: 32, date: "4/12/2013", city_id: 1)
      @station_2 = Station.create(name: "station_2", dock_count: 42, date: "6/12/2013", city_id: 1)
    end
    it "has foreign station keys" do
      trip = Trip.create(duration: "111",
                                start_date: "6/12/2015",
                                start_station: @station_1,
                                end_date: "6/13/2015",
                                end_station: @station_2,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )

      expect(trip.start_station).to eq(@station_1)
      expect(trip.end_station).to eq(@station_2)
    end
  end

  describe "trip calculations" do
    before(:each) do
      station_data = CSVLoader.new.sanitize_station('./db/csv/station.csv')
      station_data.each do |station|
        if City.find_by(name: station[:city]).nil?
          city = City.create(name: station[:city])
        else
          city = City.find_by(name: station[:city])
        end

        Station.create(id: station[:id],
          name: station[:name],
          dock_count: station[:dock_count],
          city_id: city.id,
          date: station[:date]
          )
      end

      trip_data = CSVLoader.new.sanitize_trips('./spec/fixtures/trip_fixture.csv')
      trip_data.each do |trip|
        start_station = Station.find(trip[:start_station_id])
        end_station = Station.find(trip[:start_station_id])

        Trip.create(id: trip[:id],
          duration: trip[:duration],
          start_date: trip[:start_date],
          start_station: start_station,
          end_date: trip[:end_date],
          end_station: end_station,
          bike_id: trip[:bike_id],
          subscription_type: trip[:subscription_type],
          zip_code: trip[:zip_code]
          )
      end
    end

    it 'calculates average duration of a ride' do
      expect(Trip.average_duration_of_a_ride).to eq(394)
    end

    it 'calculates the longest ride' do
      expect(Trip.longest_ride).to eq(528)
    end
  end
end
