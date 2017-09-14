class Referral < ActiveRecord::Base
  attr_accessible :name, :refkey

  has_many :consumers

  validates :refkey, :presence => true
  validates_uniqueness_of :refkey

  paginates_per 10

  def self.search (key)
    unless key.nil? or key.empty?
      where("lower(refkey) LIKE ? or lower(name) LIKE ?", "%#{key.downcase}%", "%#{key.downcase}%")
    else
      Kaminari.paginate_array(all)
    end
  end
end
