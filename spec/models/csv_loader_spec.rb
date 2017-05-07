require_relative '../spec_helper'

RSpec.describe CSVLoader do
  describe 'parsing a csv file' do
    before(:each) do
      @dummy = CSVLoader.new
      @file = CSVLoader.open('./db/csv/station.csv')
    end

    it 'returns csv object' do
      expect(@file).to be_instance_of(CSV)
    end

    it 'has a count of 70' do
      expect(@file.readlines.size).to eq(70)
    end

    it 'can convert file to array of hashes' do
      data = @dummy.to_array('./db/csv/station.csv')

      expect(data).to be_instance_of(Array)
      data.each do |row|
        expect(row).to be_instance_of(Hash)
      end
    end

    it 'returns array of csv rows' do
      query = {search_in: 'name', find: 'San Jose Diridon Caltrain Station'}
      data = @dummy.find_records(@file, query)
      expect(data).to be_instance_of(Array)

      data.each do |row|
        expect(row).to be_instance_of(CSV::Row)
      end
    end
  end

  describe 'adding info for seed file' do
    before(:each) do
      dummy = CSVLoader.new
      @file = dummy.open('./db/csv/station.csv')
    end

    it ''
  end
end