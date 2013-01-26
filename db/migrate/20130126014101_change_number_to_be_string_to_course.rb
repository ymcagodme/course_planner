class ChangeNumberToBeStringToCourse < ActiveRecord::Migration
  def change
    change_column :courses, :number, :string, :unique => true,
                                              :null   => false
  end
end
