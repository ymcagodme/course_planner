class AddCodeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :code, :string

    add_index :courses, :code, unique: true
  end
end
