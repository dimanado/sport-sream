class Company < ActiveRecord::Base
  has_attachment :avatar, accept: [:jpg, :png, :gif]
end
