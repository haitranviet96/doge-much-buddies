class RenameEventsWhenColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :when, :event_datetime
  end
end
