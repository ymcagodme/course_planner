class CreateUserCourseships < ActiveRecord::Migration
  def change
    create_table :user_courseships do |t|
      t.string :user_id
      t.string :course_id

      t.timestamps
    end
  end
end
