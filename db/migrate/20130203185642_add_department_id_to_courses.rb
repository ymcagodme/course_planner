class AddDepartmentIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :department_id, :integer

    add_index :courses, :department_id
  end
end
