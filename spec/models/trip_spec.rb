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
                                start_date: Date.today,
                                start_station_id: @station_1.id,
                                end_date: Date.today,
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(valid_trip).to be_valid

      no_duration = Trip.create(
                                start_date: Date.today,
                                start_station_id: @station_1.id,
                                end_date: Date.today,
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(no_duration).not_to be_valid

      no_start_date = Trip.create(duration: "111",
                                  start_station_id: @station_1.id,
                                  end_date: Date.today,
                                  end_station_id: @station_2.id,
                                  bike_id: 1,
                                  subscription_type: "subscriber"
                                  )
      expect(no_start_date).not_to be_valid

      no_start_station = Trip.create(duration: "111",
                                start_date: Date.today,
                                end_date: Date.today,
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(no_start_station).not_to be_valid

      no_end_date = Trip.create(duration: "111",
                                start_date: Date.today,
                                start_station_id: @station_1.id,
                                end_station_id: @station_2.id,
                                bike_id: 1,
                                subscription_type: "subscriber"
                                )
      expect(no_end_date).not_to be_valid

      no_end_station = Trip.create(duration: "111",
                                   start_date: Date.today,
                                   start_station_id: @station_1.id,
                                   end_date: Date.today,
                                   bike_id: 1,
                                   subscription_type: "subscriber"
                                   )
      expect(no_end_station).not_to be_valid

      no_bike = Trip.create(duration: "111",
                            start_date: Date.today,
                            start_station_id: @station_1.id,
                            end_date: Date.today,
                            end_station_id: @station_2.id,
                            subscription_type: "subscriber"
                            )
      expect(no_bike).not_to be_valid

      no_subscription_type = Trip.create(duration: "111",
                                         start_date: Date.today,
                                         start_station_id: @station_1.id,
                                         end_date: Date.today,
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
                                start_date: Date.today,
                                start_station: @station_1,
                                end_date: Date.today,
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
          start_date: Date.strptime(trip[:start_date], '%m/%d/%Y %H:%M'),
          start_station: start_station,
          end_date: Date.strptime(trip[:end_date], '%m/%d/%Y %H:%M'),
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

    it 'calculates the shortest ride' do
      expect(Trip.shortest_ride).to eq(63)
    end

    it 'finds the station with most starting rides' do
      expect(Trip.station_with_most_starting_place_rides.first.name).to eq('Market at Sansome')
    end

    it 'finds the station with most end rides' do
      expect(Trip.station_with_most_ending_place_rides.first.name).to eq('Market at Sansome')
    end

    it 'finds the most ridden bike' do
      actual = Trip.most_ridden_bike.values.first
      expect(actual).to eq(3)
    end

    it 'finds the least ridden bike' do
      actual = Trip.least_ridden_bike.values.first

      expect(actual).to eq(1)
    end

    it 'finds subscription stats' do
      expect(Trip.user_subscription_type_count[:customers]).to eq(45)
      expect(Trip.user_subscription_type_count[:subscribers]).to eq(70)
      expect(Trip.user_subscription_type_count[:customers_percentage]).to eq(39.13)
      expect(Trip.user_subscription_type_count[:subscribers_percentage]).to eq(60.87)
    end

    it 'finds busiest day' do
      expect(Trip.busiest_day[0]).to be_instance_of(Date)
    end

    it 'finds loneliest day' do
      expect(Trip.least_busy_day[0]).to be_instance_of(Date)
    end

    it 'returns month by month breakdown' do
      expect(Trip.month_by_month_breakdown).to eq({:months=>{1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8=>115, 9=>0, 10=>0, 11=>0, 12=>0}, :years=>{2013=>115, 2014=>0, 2015=>0, 2016=>0}})
    end
  end
end
