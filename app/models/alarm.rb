class Alarm < ApplicationRecord
    validates :postId, presence: true
end
