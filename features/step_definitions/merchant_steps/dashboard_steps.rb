When /^I go to the dashboard page$/ do
  visit dashboard_path
end

Then /^I should see my campaigns$/ do
  @current_merchant.campaigns.each do |campaign|
    page.should have_css("#campaign_#{campaign.id}")
  end
end

When /^I click on the first scheduled campaign$/ do
  @campaign = @current_merchant.campaigns.queued.first
  within dom_id(@campaign) do
    click_link("edit")
  end
end

When /^click on the delivered campaign$/ do
  within dom_id(@campaign) do
    click_link("stats")
  end
end

Then /^I should see a demographic breakdown chart for ((?:non-)?subscribers)$/ do |type|
  page.should have_css("##{type}-demographics")
end

Then /^I should be on my dashboard page$/ do
  current_path = URI.parse(current_url).path
  current_path.should =~ /dashboard/
end

Then /^I should see a map of my subscribers$/ do
  page.should have_css(".subscribers div.map")
end

Then /^I should see a map of consumers interested in my type of business$/ do
  page.should have_css(".interested-non-subscribers div.map")
end

Given /^I have delivered an indirect campaign$/ do
  @delivered_campaigns ||= []
  @campaign = Factory(:indirect_coupon_campaign, :business => @current_merchant.businesses.first)
  @campaign.enqueue!
  DeliverCampaignJob.perform(@campaign.id, @campaign.message_ids)
  @delivered_campaigns << @campaign
end

When /^I go to the campaign's statistics page$/ do
  visit polymorphic_path(@campaign, :action => :statistics)
end

Then /^I should be on the campaign statistics page$/ do
  page.current_path.should == polymorphic_path(@campaign, :action => :statistics)
end

Given /^I have delivered an direct campaign$/ do
  @delivered_campaigns ||= []
  @campaign = Factory(:direct_coupon_campaign, :business => @current_merchant.businesses.first)
  @campaign.enqueue!
  DeliverCampaignJob.perform(@campaign.id, @campaign.message_ids)
  @delivered_campaigns << @campaign
end

Then /^I should see the total number of subscribers$/ do
  within "#subscribers" do
    page.should have_content "Consumers that picked me (#{@business.subscribers.count})"
  end
end

Then /^I should see the total number of non\-subscribers$/ do
  within "#interested-non-subscribers" do
    page.should have_content "Consumers interested in my type of business (#{@business.interested_non_subscribers.count})"
  end
end