class Alarm < ApplicationRecord
    # has_many :posts
    # belongs_to :posts
    validates :postId, 
    presence: true
    

    validates :keywordId, 
    presence: true

end
