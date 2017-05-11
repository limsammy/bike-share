require_relative '../spec_helper'

RSpec.describe City, :type => :model do
  describe "city attributes" do
    it "must have a name attribute" do
      valid_city = City.create(name: "Denver")
      expect(valid_city).to be_valid

      invalid_city = City.create
      expect(invalid_city).not_to be_valid
    end
  end

  describe "city relationships" do
    it "has many stations" do
      date = Time.parse("08/06/2013")
      city = City.create(name: "Denver")
      station = Station.create(name: "stationicus",
                               dock_count: 42,
                               city_id: city.id,
                               date: date)
      expect(city.stations).to include(station)
    end
  end
end
