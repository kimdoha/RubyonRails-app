class AddAlarmToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :alarm, :int
  end
end
