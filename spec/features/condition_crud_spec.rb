require_relative '../spec_helper'

RSpec.describe "Condition CRUD" do
  describe "creating a weather record" do
    it "allows the user to fill out a form to create a weather condition" do
      visit("conditions/new")
      fill_in "condition[max_temperature]", with: "75"
      fill_in "condition[mean_temperature]", with: "76"
      fill_in "condition[min_temperature]", with: "64"
      fill_in "condition[mean_humidity]", with: "78.0"
      fill_in "condition[mean_visibility]", with: "10.0"
      fill_in "condition[mean_wind_speed]", with: "9.0"
      fill_in "condition[precipitation]", with: ".41"
      fill_in "condition[date]", with: "1/13/13"
      click_on "Create Weather Condition"
      expect(page).to have_content(".41")
    end
  end

  describe "weather condition index" do
    it "shows all weather conditions" do
      condition = Condition.create(
                                   max_temperature: "75",
                                   mean_temperature: "76",
                                   min_temperature: "64",
                                   mean_humidity: "78.0",
                                   mean_visibility: "10.0",
                                   mean_wind_speed: "9.0",
                                   precipitation: ".41",
                                   date: "1/1/13"
                                   )

       condition = Condition.create(
                                    max_temperature: "75",
                                    mean_temperature: "76",
                                    min_temperature: "64",
                                    mean_humidity: "78.0",
                                    mean_visibility: "10.0",
                                    mean_wind_speed: "9.0",
                                    precipitation: ".41",
                                    date: "1/2/13"
                                    )

      visit("/conditions")
      expect(page).to have_content("1/2/13")
      expect(page).to have_content("1/2/13")
    end
  end

  describe "updating conditions" do
    it "allows the user to update a weather condition" do
      condition = Condition.create(
                                   max_temperature: "75",
                                   mean_temperature: "76",
                                   min_temperature: "64",
                                   mean_humidity: "78.0",
                                   mean_visibility: "10.0",
                                   mean_wind_speed: "9.0",
                                   precipitation: ".41",
                                   date: "1/1/13"
                                   )

      visit("conditions/#{ condition.id }/edit")
      fill_in "condition[min_temperature]", with: "58"
      click_on "Update Weather Condition"
      expect(page).to have_current_path("/conditions/#{ condition.id }")
      expect(page).to have_content("58")

      visit("/conditions")
      click_on("Edit Condition")
      fill_in "condition[min_temperature]", with: "59"
      click_on "Update Weather Condition"
      expect(page).to have_current_path("/conditions/#{ condition.id }")
      expect(page).to have_content("59")
    end
  end

  describe "deleting conditions" do
    it "allows the user to delete a condition" do
      condition = Condition.create(
                                   max_temperature: "75",
                                   mean_temperature: "76",
                                   min_temperature: "64",
                                   mean_humidity: "78.0",
                                   mean_visibility: "10.0",
                                   mean_wind_speed: "9.0",
                                   precipitation: ".41",
                                   date: "1/1/13"
                                   )
      count_before_delete = Condition.count
      visit("/conditions/#{condition.id}")
      click_on "Delete Condition"
      count_after_delete = Condition.count
      expect(count_before_delete - count_after_delete).to eq(1)
      expect(page).to have_current_path("/conditions")

      condition = Condition.create(
                                   max_temperature: "75",
                                   mean_temperature: "76",
                                   min_temperature: "64",
                                   mean_humidity: "78.0",
                                   mean_visibility: "10.0",
                                   mean_wind_speed: "9.0",
                                   precipitation: ".41",
                                   date: "1/1/13"
                                   )
      visit("/conditions")
      count_before_delete = Condition.count
      click_on "Delete Condition"
      count_after_delete = Condition.count
      expect(count_before_delete - count_after_delete).to eq(1)
      expect(page).to have_current_path("/conditions")
    end
  end
end
