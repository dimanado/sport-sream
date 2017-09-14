Feature: A merchant has a dashboard

  As a merchant that logs in to mychinoki
  I want to see important information on the dashboard
  So that I can decide what kind of action I want to perform

  Scenario: I want to be able to create a coupon campaign
    Given I am a signed in merchant
    When I go to the dashboard page
    Then I should be able to create a new coupon campaign

  Scenario: I want to be able to create a notification campaign
    Given I am a signed in merchant
    When I go to the dashboard page
    Then I should be able to create a new notification campaign

  Scenario: I want to edit enqueued campaigns
    Given I have created some campaigns
    When I go to the dashboard page
    And I follow "Scheduled"
    And I click on the first scheduled campaign
    Then I should be able to edit that campaign

  Scenario: I want to see demographic statistics
    Given I have some subscribers for my business
    When I go to the dashboard page
    Then I should see a demographic breakdown chart for subscribers
    And I should see the total number of subscribers

  Scenario: I want to see geographic breakdown of my subscribers
    Given I have some subscribers for my business
    When I go to the dashboard page
    Then I should see a map of my subscribers

  Scenario: I want to see geographic breakdown of consumers interested in my type of business
    Given I have some subscribers for my business
    When I go to the dashboard page
    Then I should see a map of consumers interested in my type of business

  Scenario: I want to see demographic breakdown of consumers interested in my type of business
    Given I have some subscribers for my business
    When I go to the dashboard page
    Then I should see a demographic breakdown chart for non-subscribers
    And I should see the total number of non-subscribers