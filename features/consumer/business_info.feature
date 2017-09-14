Feature: Business info
  In order to learn more about a business
  As a consumer
  I want to be able to view the public profile of a business

  Scenario: Viewing a business to which I am subscribed
    Given I am a registered consumer
    And the system contains some businesses
    When I am subscribed to a business
    And I go to the business' info page
    Then I should see a heading with the business' name
    And I should see the business' contact information
    And I should see a description of the business
    And I should see a link to the business' website

  Scenario: Subscribing to a business
    Given I am a registered consumer
    And the system contains some businesses
    When I am not subscribed to a business
    And I go to the business' info page
    Then I should be able to subscribe to the business

  Scenario: Unsubscribing from a business
    Given I am a registered consumer
    And the system contains some businesses
    When I am subscribed to a business
    And I go to the business' info page
    Then I should be able to unsubscribe from the business