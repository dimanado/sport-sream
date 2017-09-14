Feature: New Consumer signup
  In order to receive promotional materials from chinoki businesses
  As a consumer
  I want the ability to create a user account with my personal information

  Scenario: Registration Form
    Given I am on the consumer signup page
    Then I should be able to enter a email address
    And I should be able to enter a password
    And I should have to confirm the password
    And I should be able to enter a birth year
    And I should be able to enter a location
    And I should be able to enter a gender
