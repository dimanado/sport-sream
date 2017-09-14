class Stream < ActiveRecord::Base
	validates :title, presence: true
	validates :link, format: { with: /^https?:\/\/youtube.com\/.+?$/, message: "not a youtube link" }

	validates_presence_of :company
end
