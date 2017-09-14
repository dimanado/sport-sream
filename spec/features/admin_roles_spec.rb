require 'spec_helper'
describe "admin roles" do
  it "partner cannot create partners" do
    admin = Partner.create()
    ability = Ability.new(admin)
    assert ability.cannot?(:create, Partner)
  end

  it "admin can create partners" do
    admin = Partner.new
    admin.role = 'admin'
    ability = Ability.new(admin)
    assert ability.can?(:create, Partner)
  end
end
