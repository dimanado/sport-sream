class Company < ActiveRecord::Base
	validates :title, presence: true, uniqueness: 
	validates :description, presence: true
  has_attachment :avatar, accept: [:jpg, :png, :gif]
end