require 'csv'
require_relative '../app/models/csv_loader'
require_relative '../app/models/station'
require_relative '../app/models/city'
require_relative '../app/models/trip'
require_relative '../app/models/condition'

loader = CSVLoader.new

station_data = loader.sanitize_station('./db/csv/station.csv')
station_data.each do |station|
  puts "Seeding db_stations with: #{station[:name]}"

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

trip_data = loader.sanitize_trips('./db/csv/trip.csv')
count = 0
trip_data.each do |trip|
  count += 1
  puts "Seeding db_trips count: #{count}"

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


weather_data = loader.sanitize_weather('./db/csv/weather.csv')
count = 0
weather_data.each do |condition|
  count += 1
  puts "Seeding db_conditions count: #{count}"
  Condition.create(max_temperature: condition[:max_temperature],
                   mean_temperature: condition[:mean_temperature],
                   min_temperature: condition[:min_temperature],
                   mean_humidity: condition[:mean_humidity],
                   mean_visibility: condition[:mean_visibility],
                   mean_wind_speed: condition[:mean_wind_speed],
                   precipitation: condition[:precipitation],
                   date: condition[:date]
                   )
end
