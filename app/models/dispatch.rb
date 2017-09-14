class Dispatch < ActiveRecord::Base
  attr_accessible :partner_id
  
  belongs_to :partner
  has_and_belongs_to_many :materials
  has_many :dispatch_recipients
end