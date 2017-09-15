class Stream < ActiveRecord::Base
	has_one :category
	belongs_to :location

	validates :title, presence: true
	validates :link, format: { with: /^https?:\/\/www\.youtube\.com\/.+?$/, message: "not a youtube link" }

	validates_presence_of :location_id
end
