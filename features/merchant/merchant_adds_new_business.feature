Feature: merchant add new business

	In order avoid having to maintain multiple login credentials 
	As a merchant with many businesses
	I want the ability to add all of my businesses to my merchant account

	Scenario: Merchant adds a second business.
		Given the system contains categories
    And I am a signed in merchant
		And I go to the dashboard page
    When I follow "Businesses" from the left nav
		And I click "Add another business"
		And I edit the business information
		And I press "Add Business"
		Then I should see 2 businesses in my business selector
