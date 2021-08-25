class FixColumnName < ActiveRecord::Migration[6.1]
  def change

    # users table 수정 
    rename_column :users, :userId, :id
    rename_column :users, :nickName, :nick_name
    rename_column :users, :createAt, :create_at
    rename_column :users, :updateAt, :update_at

    # posts table 수정
    rename_column :posts, :postId, :id
    rename_column :posts, :userId, :user_id
    rename_column :posts, :imageUrl, :image_url
    rename_column :posts, :createAt, :create_at
    rename_column :posts, :updateAt, :update_at

    # keywords table 수정
    rename_column :keywords, :keywordId, :id
    rename_column :keywords, :userId, :user_id
    rename_column :keywords, :createAt, :create_at

    # alarms table 수정
    rename_column :alarms, :alarmId, :id
    rename_column :alarms, :userId, :user_id
    rename_column :alarms, :postId, :post_id
    rename_column :alarms, :keywordId, :keyword_id
    rename_column :alarms, :createAt, :create_at



  end
end
