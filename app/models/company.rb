class Company < ActiveRecord::Base
	validates :title, presence: true, uniqueness: 
	validates :description, presence: true
end