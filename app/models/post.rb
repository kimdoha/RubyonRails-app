class Post < ApplicationRecord
    # belongs_to :alarms
    # has_many :alarms
    validates :title, 
    presence: true, 
    length: { in: 2..30 }     # 글자 수 : 2 ~ 30

    validates :content, 
    presence: true, 
    length: { minimum: 2 }  # 최소 두 글자

    validates :imageUrl, 
    presence: true, 
    format: { with: /[\S]+((i?).(jpg|png|jpeg|bmp))/,
    message: "unaccurate image format" }    # 이미지 포맷 정규표현식(png | jpeg 형식) 사용                    
end
