require_relative '../spec_helper'

RSpec.describe "Station CRUD" do
  describe "creating a station" do
    it "allows the user to fill out a form to create a station" do
      city = City.create(name: "San Jose")
      visit("/stations/new")
      fill_in "station[name]", with: "stationicus"
      fill_in "station[dock_count]", with: "42"
      find('.city-selector').find(:xpath, 'option[1]').select_option
      fill_in "station[date]", with: "8/6/2013"
      click_on "Create Station"

      expect(page).to have_content("stationicus")
    end
  end

  describe "reading stations" do
    it "allows the user to see an index of stations, and a single station" do
      city = City.create(name: "San Jose")
      visit("/stations/new")
      fill_in "station[name]", with: "station 1"
      fill_in "station[dock_count]", with: "42"
      find('.city-selector').find(:xpath, 'option[1]').select_option
      fill_in "station[date]", with: "8/6/2013"
      click_on "Create Station"

      visit("/stations/new")
      fill_in "station[name]", with: "station 2"
      fill_in "station[dock_count]", with: "43"
      # find('.city-selector').find(:xpath, 'option[1]').select_option
      find('.city-selector').find(:xpath, 'option[1]').select_option
      fill_in "station[date]", with: "8/6/2013"
      click_on "Create Station"

      visit("/stations")
      expect(page).to have_content("station 1")
      expect(page).to have_content("station 2")

      first(:link, 'station 1').click
      expect(page).to have_content("42")
      visit("/stations")
      first(:link, 'station 2').click
      expect(page).to have_content("43")
    end

    describe "updating stations" do
      it "allows the user to update a station" do
        city = City.create(name: "San Jose")
        station = Station.create(name: "stationary", dock_count: 42, city_id:
          city.id, date: "8/8/16")
        visit("/stations/#{station.id}/edit")
        fill_in "station[name]", with: "stationary 2"
        fill_in "station[dock_count]", with: "43"
        find('.city-selector').find(:xpath, 'option[1]').select_option
        fill_in "station[date]", with: "8/6/2014"
        click_on "Update Station"

        expect(page).to have_current_path("/stations/#{ station.id }")
        expect(page).to have_content("stationary 2")
      end
    end

    describe "deleting stations" do
      it "allows the user to delete a station" do
        city = City.create(name: "San Jose")
        station = Station.create(name: "DeleteThisStation", dock_count: 42, city_id:
          city.id, date: "8/8/16")
        count_before_delete = Station.count
        visit("/stations/#{station.id}")
        click_on "Delete"
        count_after_delete = Station.count

        expect(count_before_delete - count_after_delete).to eq(1)
        expect(page).to have_current_path("/stations")
      end
    end
  end
end
