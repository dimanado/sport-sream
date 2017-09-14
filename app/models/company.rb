class Company < ActiveRecord::Base
  has_many :locations

	validates :title, presence: true, uniqueness: true
	validates :description, presence: true

  has_attachment :avatar, accept: [:jpg, :png, :gif]
end