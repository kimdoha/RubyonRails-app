class User < ApplicationRecord
    validates :nick_name, 
    presence: true

    validates :alarm, 
    presence: true

end
