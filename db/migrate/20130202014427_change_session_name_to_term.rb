class ChangeSessionNameToTerm < ActiveRecord::Migration
  def change
    rename_column :terms, :session, :season
  end
end
