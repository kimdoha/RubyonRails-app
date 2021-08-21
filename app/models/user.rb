class User < ApplicationRecord
    validates :nickName, 
    presence: true

    validates :alarm, 
    presence: true

end
