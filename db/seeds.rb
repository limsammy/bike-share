require 'csv'
require_relative '../app/models/csv_loader'
require_relative '../app/models/station'
require_relative '../app/models/city'

loader = CSVLoader.new
data = loader.sanitize_station('./db/csv/station.csv')

data.each do |station|
  puts "Seeding db_stations with: #{station[[:name]]}"

  if City.find_by(name: station[[:city]]).nil?
    city = City.create!(
                     name: station[[:city]]
    )
  else
    city = City.find_by(name: station[[:city]])
  end

  Station.create!(
                    name: station[[:name]],
                    dock_count: station[[:dock_count]],
                    city_id: city.id,
                    date: station[[:date]]
                  )
end
