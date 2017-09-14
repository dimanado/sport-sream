class Hashtag < ActiveRecord::Base
  attr_accessible :tag
  has_and_belongs_to_many :coupons
end
