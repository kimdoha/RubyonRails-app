class AddKeywordIdToAlarm < ActiveRecord::Migration[6.1]
  def change
    add_column :alarms, :keywordId, :int
  end
end
