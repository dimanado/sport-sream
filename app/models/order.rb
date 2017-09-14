class Order < ActiveRecord::Base
  attr_accessible :consumer_id, :offer_id, :partner_id, :redemption_code, :status

  belongs_to :consumer
  belongs_to :offer, foreign_key: 'offer_id', class_name: 'Coupon' 
end
