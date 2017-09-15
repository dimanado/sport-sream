class Stream < ActiveRecord::Base
	has_one :category

	validates :title, presence: true
	validates :link, format: { with: /^https?:\/\/youtube.com\/.+?$/, message: "not a youtube link" }

	validates_presence_of :company
end
