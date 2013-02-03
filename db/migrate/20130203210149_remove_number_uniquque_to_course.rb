class RemoveNumberUniququeToCourse < ActiveRecord::Migration
  def change
    change_column :courses, :number, :string, unique: false
  end
end
