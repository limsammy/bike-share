class FixDateType < ActiveRecord::Migration[5.0]
  def change
    change_column :stations, :date, :string
  end
end
