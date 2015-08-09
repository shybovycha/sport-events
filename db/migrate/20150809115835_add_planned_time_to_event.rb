class AddPlannedTimeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :planned_time, :datetime, null: false
  end
end
