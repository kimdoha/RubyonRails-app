class Keyword < ApplicationRecord
    validates :keyword, 
    presence: true, 
    format: { with: /([가-힣\x20])/,
    message: "unable keyword " }    # 정규표현식 : 추가할 수 없는 키워드(초성 AND 모음)        
end
