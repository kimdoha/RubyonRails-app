class Post < ApplicationRecord
    # belongs_to :alarms
    # has_many :alarms
    validates :title, presence: true
    validates :content, presence: true
end
