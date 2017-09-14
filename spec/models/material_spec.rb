require 'spec_helper'

describe Material do
  it "has valid factory" do
    expect(create(:material)).to be_valid
  end

  it "#full_path" do
    material = FactoryGirl.create(:material)
    expect(material.full_path).to eq 'https://res.cloudinary.com/hooditt-com/image/upload/' + material.file.path
  end
end
