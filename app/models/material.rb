require 'open-uri'
class Material < ActiveRecord::Base
  attr_accessible :type_of_file, :title, :public

  has_and_belongs_to_many :dispatches
  has_many :partner, through: :dispatches
  has_many :material_downloads

  has_attachment  :file
  validates :type_of_file, :file, :presence => true

  scope :files, where(type_of_file: 'file')
  scope :images, where(type_of_file: 'image')


  def full_path
    if file.resource_type == "raw"
      "https://res.cloudinary.com/hooditt-com/raw/upload/" + file.path
    else
      "https://res.cloudinary.com/hooditt-com/image/upload/" + file.path
    end
  end
end