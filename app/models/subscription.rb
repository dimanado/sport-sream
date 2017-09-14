class Subscription < ActiveRecord::Base
  belongs_to :business
  belongs_to :consumer
end
