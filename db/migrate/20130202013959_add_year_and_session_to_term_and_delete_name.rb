class AddYearAndSessionToTermAndDeleteName < ActiveRecord::Migration
  def change
    remove_column :terms, :name

    add_column :terms, :year, :integer
    add_column :terms, :session, :string

    add_index :terms, :year
  end
end
