require 'csv'
require_relative '../app/models/csv_loader'

CSV.foreach("db/csv/csv_data.csv", { encoding: "UTF-8", headers: ['name', 'dock_count', 'city', 'installation_date'], header_converters: :symbol, converters: :all}) do |row|
  Station.create(CSVLoader.sanitize_for_entry(row.to_hash))
end