require 'pry'
require 'csv'
require 'pry'

class CSVLoader
  def self.open(file_name)
    CSV.open file_name, headers:true, header_converters: :symbol
  end

  def to_array(file_name)
    csv = CSV::parse(File.open(file_name, 'r') {|f| f.read })
    fields = csv.shift
    fields = fields.map {|f| f.downcase.gsub(" ", "_")}
    csv.collect { |record| Hash[*fields.zip(record).flatten ] }
  end

  def find_records(contents, query)
    search_in = query[:search_in].to_sym
    search_for = query[:find]
    result = contents.select do |row|
      row[search_in] == search_for
    end
    result
  end
  # Might just need this method vvvvvv but saving ^ for later iterations
  def sanitize_station(path)
    data = CSV.open(path, headers: true, header_converters: :symbol)

    data.map do |row|
      # binding.pry
      {
        :id => row[:id],
        :name => row[:name],
        :dock_count => row[:dock_count].to_i,
        :city => row[:city],
        :date => row[:installation_date] # Should we make this an integer for calcs?
      }
    end
  end

  def sanitize_trips(path)
    data = CSV.open(path, headers: true, header_converters: :symbol)

    data.map do |row|
      {
        :id => row[:id],
        :duration => row[:duration],
        :start_date => row[:start_date],
        :start_station_id => row[:start_station_id].to_i,
        :end_date => row[:end_date],
        :end_station_id => row[:end_station_id].to_i,
        :bike_id => row[:bike_id].to_i,
        :subscription_type => row[:subscription_type].downcase,
        :zip_code => row[:zip_code].to_i
      }
    end
  end

  def sanitize_weather(path)
    data = CSV.open(path, headers: true, header_converters: :symbol)

    data.map do |row|
      if row[:precipitation_inches] == 'T'
        row[:precipitation_inches] = 0
      end
      {
        :date => row[:date],
        :max_temperature => row[:max_temperature_f],
        :mean_temperature => row[:mean_temperature_f],
        :min_temperature => row[:min_temperature_f],
        :mean_humidity => row[:mean_humidity],
        :mean_visibility => row[:mean_visibility_miles],
        :mean_wind_speed => row[:mean_wind_speed_mph],
        :precipitation => row[:precipitation_inches]
      }
    end
  end
end
