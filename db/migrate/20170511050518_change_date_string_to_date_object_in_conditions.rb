class ChangeDateStringToDateObjectInConditions < ActiveRecord::Migration[5.0]
  def change
    change_column(:conditions, :date, 'date USING CAST(date AS date)')
  end
end
