class Category < ActiveRecord::Base
  extend ActsAsTree::TreeView
  acts_as_tree

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :businesses
  has_and_belongs_to_many :companies
  has_many :subcategories, :foreign_key => 'parent_id', :class_name => 'Category'

  belongs_to :stream

  accepts_nested_attributes_for :subcategories, :allow_destroy => true
  #belongs_to :category, :foreign_key => 'parent_id'
  attr_accessible :name

  scope :top_level, where(:parent_id => nil).includes(:children)

  def self.for_grouped_select
    top_level.map do |category|
      sub_categories = category.children.map{|c| [c.name, c.id]}
      sub_categories.unshift(["All #{category.name}", category.id])
      [category.name, sub_categories]
    end
  end

  def self.count_consumers
    Hash[top_level.map { |cat| [cat.name, cat.consumers_count] }]
  end

  def self.count_businesses
    Hash[top_level.map { |cat| [cat.name, cat.businesses_count] }]
  end

  def top_level?
    parent_id == nil
  end

  def has_subcategories?
    not child_ids.empty?
  end

  def businesses_count
    result = businesses.size
    collection = []

    if children
      children.each {|c| collection += c.businesses}
      collection = collection.uniq
    end
    result + collection.size
  end

  def consumers_count
    result = consumers.size
    collection = []

    if children
      children.each {|c| collection += c.consumers}
      collection = collection.uniq
    end
    result + collection.size
  end
end
