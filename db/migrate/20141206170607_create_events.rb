class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :sport
      t.text :description
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
