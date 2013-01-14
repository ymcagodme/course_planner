class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :number
      t.string  :title
      t.string  :instructor
      t.string  :status
      t.integer :available_seats
      t.integer :term

      t.timestamps
    end

    add_index :courses, :number
    add_index :courses, :instructor
    add_index :courses, :status
    add_index :courses, :term
  end
end
