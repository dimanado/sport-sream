class Location < ActiveRecord::Base
  attr_accessible :name, :zip_code, :company_id

  has_many :streams
  belongs_to :consumer
  belongs_to :company
  geocoded_by :zip_code

  validates :zip_code, :format => {:with => /^\d{5}(-\d{4})?$/}
  # validates_presence_of :consumer
  validates_presence_of :company_id

  after_validation :geocode, :if => :zip_code_changed?

  has_attachment :avatar, accept: [:jpg, :png, :gif]
  has_attachments :photos

end
