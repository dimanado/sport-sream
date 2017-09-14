Feature: Categories
  In order to receive deals from businesses that I might not know about, but whose products I am interested in
  As a consumer
  I want to be able to specify the types of products and services that interest me

  Scenario: Setting product/service preferences
    Given I am a registered consumer
    And the system contains categories
    When I go to the consumer interests page
    Then I should be able to choose which categories of products interest me