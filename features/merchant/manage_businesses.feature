Feature: Managing Businesses

  As a merchant
  I want the ability to manage my businesses
  So I can keep information about my businesses current

  Background:


  Scenario: Editing a business' information
    Given the system contains categories
    And I am a signed in merchant
    When I visit a business profile
    And I press "Save"
    Then I should be on the business profile page
