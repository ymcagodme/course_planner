class RemoveTermAndAddTermIdToCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :term
    add_column :courses, :term_id, :integer

    add_index :courses, :term_id
  end
end
