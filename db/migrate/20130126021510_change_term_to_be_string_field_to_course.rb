class ChangeTermToBeStringFieldToCourse < ActiveRecord::Migration
  def change
    change_column :courses, :term, :string
  end
end
