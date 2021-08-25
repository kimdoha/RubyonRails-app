class Alarm < ApplicationRecord
    belongs_to :post
    belongs_to :keyword


    validates :post_id, 
    presence: true
    

    validates :keyword_id, 
    presence: true

end
