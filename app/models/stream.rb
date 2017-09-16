class Stream < ActiveRecord::Base
	attr_accessible :title, :link, :location_id

	has_one :category
	belongs_to :location

	validates :title, presence: true
	validates :link, format: { with: /^https?:\/\/www\.youtube\.com\/.+?$/, message: "not a youtube link" }

	validates_presence_of :location_id

	has_attachment :avatar, accept: [:jpg, :png, :gif]
end
