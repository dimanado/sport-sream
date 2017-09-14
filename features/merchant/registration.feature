Feature: A merchant can register for Hooditt

  As a merchant interested in Hooditt's services
  I want to be able to register
  So I can see what value I might get out of the system

  Scenario: I can register for the service
    Given the system contains categories
    And I am on the merchant registration page
    When I provide the required information
    Then I should be on my dashboard page
