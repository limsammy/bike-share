ENV["RACK_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec'
require 'capybara/dsl'
require 'pry'
require 'database_cleaner'


require_relative '../app/models/csv_loader'

Capybara.app = BikeShareApp

RSpec.configure do |c|
  c.include Capybara::DSL
  c.before(:all) do
    DatabaseCleaner.clean
  end
  c.after(:each) do
    DatabaseCleaner.clean
  end
end
