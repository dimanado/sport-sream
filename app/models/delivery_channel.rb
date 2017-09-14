class DeliveryChannel < ActiveRecord::Base

  def self.types
    subclasses.map(&:human_name)
  end
  def self.human_name
    name.demodulize
  end

  def to_s
    name
  end

  def human_name
    self.class.human_name
  end

  def direct?
    false
  end
end

#loads the subclasses
Dir["app/models/delivery_channel/*.rb"].each {|d| load d}
