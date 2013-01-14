class AddUniquenessOfNumberToCourse < ActiveRecord::Migration
  def change
    change_column :courses, :number, :integer, :unique => true
  end
end
