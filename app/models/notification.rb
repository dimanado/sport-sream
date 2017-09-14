class Notification < ActiveRecord::Base
  attr_accessible :body, :status, :subject, :sender_id, :recipient_id
  belongs_to :sender, :class_name => "Partner"
  belongs_to :recipient, :class_name => "Partner"
  validates :body, :presence => true, :length => { in: 5..300 }
end
