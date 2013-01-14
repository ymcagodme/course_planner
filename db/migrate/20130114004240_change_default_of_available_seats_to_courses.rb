class ChangeDefaultOfAvailableSeatsToCourses < ActiveRecord::Migration
  def change
    change_column :courses, :available_seats, :integer, :default => 0
  end
end
