class ChangeCodeToTerm < ActiveRecord::Migration
  def change
    change_column :terms, :code, :string, :unique => true
  end
end
