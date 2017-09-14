class Location < ActiveRecord::Base
  attr_accessible :name, :zip_code

  belongs_to :consumer
  belongs_to :company
  geocoded_by :zip_code

  validates :zip_code, :format => {:with => /^\d{5}(-\d{4})?$/}
  validates_presence_of :consumer
  after_validation :geocode, :if => :zip_code_changed?

end
