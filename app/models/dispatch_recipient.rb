class DispatchRecipient < ActiveRecord::Base
  belongs_to :dispatch
  attr_accessible :email, :status, :dispatch_id
end
