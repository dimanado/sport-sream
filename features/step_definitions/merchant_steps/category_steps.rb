Given /^the system contains categories$/ do
  @category = Factory(:category, :name => 'Restaurants')
  @category.children.create :name => 'Cafe'
  @category.children.create :name => 'Chinese'
  @category.children.create :name => 'Indian'
  @category.children.create :name => 'Italian'
  @category.children.create :name => 'Japanese'
  @category.children.create :name => 'Thai'
end
