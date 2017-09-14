Feature: Business Index
  In order to receive coupons which will drive me to spend ridiculous amounts of money
  As a consumer
  I want the ability to browse the ability to subscribe to chinoki businesses

  Scenario: Listing businesses
    Given I am a registered consumer
    And the system contains some businesses
    When I go to the businesses index page
    Then I should see a list of the chinoki businesses

  Scenario: Searching businesses
    Given I am a registered consumer
    When I go to the businesses index page
    Then I should be able to search for a business by name

  Scenario: Subscribing to a business
    Given I am a registered consumer
    And the system contains some businesses
    When I am not subscribed to a business
    And I go to the businesses index page
    Then I should be able to subscribe to the business

  Scenario: Unsubscribing from a business
    Given I am a registered consumer
    And the system contains some businesses
    When I am subscribed to a business
    And I go to the businesses index page
    Then I should be able to unsubscribe from the business

  Scenario: Searching for subscribed businesses
    Given I am a registered consumer
    When I go to the businesses index page
    Then I should be able to filter by subscribed status


