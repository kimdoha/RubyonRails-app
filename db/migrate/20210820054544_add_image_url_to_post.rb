class AddImageUrlToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :imageUrl, :text
  end
end
