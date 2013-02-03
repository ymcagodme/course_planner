class ChangeCodeAndNumberToCourse < ActiveRecord::Migration
  def change
    change_column :courses, :number, :string
    change_column :courses, :code,   :string, unique: true
  end
end
