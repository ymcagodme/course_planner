class ChangeUserIdAndCourseIdTypeToUserCourseship < ActiveRecord::Migration
  def change
    change_column :user_courseships, :user_id,   :integer, :null => false
    change_column :user_courseships, :course_id, :integer, :null => false

    add_index :user_courseships, :user_id
    add_index :user_courseships, :course_id
  end
end
