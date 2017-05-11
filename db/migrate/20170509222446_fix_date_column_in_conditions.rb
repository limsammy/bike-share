class FixDateColumnInConditions < ActiveRecord::Migration[5.0]
  def change
    remove_column :conditions, :duration
    add_column :conditions, :date, :string
  end
end
