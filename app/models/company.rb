class Company < ActiveRecord::Base
  has_many :locations
  has_many :categories

	validates :title, presence: true, uniqueness: true
	validates :description, presence: true

  has_attachment :avatar, accept: [:jpg, :png, :gif]
end