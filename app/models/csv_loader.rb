require 'pry'
require 'csv'

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
  def self.sanitize(row)
    CSV.delete(:lat)
    CSV.delete(:long)
  end
end