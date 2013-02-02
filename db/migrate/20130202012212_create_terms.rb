class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name
      t.string :code

      t.timestamps
    end

    add_index :terms, :name
    add_index :terms, :code
  end
end
