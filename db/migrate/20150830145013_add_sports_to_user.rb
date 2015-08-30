class AddSportsToUser < ActiveRecord::Migration
  def change
    add_column :users, :sports, :string
  end
end
