class Company < ActiveRecord::Base
  attr_accessible :title, :description

  has_many :locations
  has_many :categories
  has_and_belongs_to_many :merchants

	validates :title, presence: true, uniqueness: true
	validates :description, presence: true

  has_attachment :avatar, accept: [:jpg, :png, :gif, :svg]
end
