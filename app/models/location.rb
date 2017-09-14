class Location < ActiveRecord::Base
  attr_accessible :name, :zip_code

  belongs_to :consumer
  geocoded_by :zip_code

  validates :zip_code, :format => {:with => /^\d{5}(-\d{4})?$/}
  validates_presence_of :consumer
  validates_presence_of :company
  
  after_validation :geocode, :if => :zip_code_changed?

end
