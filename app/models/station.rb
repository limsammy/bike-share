class Station < ActiveRecord::Base
  validates :name, :dock_count, :city, :date, presence: true

end
