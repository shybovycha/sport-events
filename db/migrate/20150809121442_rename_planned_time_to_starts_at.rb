class RenamePlannedTimeToStartsAt < ActiveRecord::Migration
  def change
    rename_column :events, :planned_time, :starts_at
  end
end
