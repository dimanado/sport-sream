Feature: Billing History

  In order to keep track of the money I'm spending and services I'm receiving from Hooditt
  As a merchant
  I want to be able to view a history of charges to my account

  Scenario: Viewing Billing History
    Given I am a signed in merchant
    And I have purchased services
    When I go to the billing history page
    Then I should see a table of my past transactions
    And I should see a link to update my billing information