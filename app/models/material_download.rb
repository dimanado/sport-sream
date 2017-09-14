class MaterialDownload < ActiveRecord::Base
  belongs_to :partner
  belongs_to :material
  # attr_accessible :title, :body
end
