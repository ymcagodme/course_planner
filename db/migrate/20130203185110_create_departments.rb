class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :abbr, unique: true
      t.string :name, unique: true

      t.timestamps
    end

    add_index :departments, :abbr
  end
end
