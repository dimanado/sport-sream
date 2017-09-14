Feature: Consumer Profile
  In order to maintain current information about myself
  As a consumer
  I want to manage my consumer profile

  Scenario: Message Delivery Preferences
    Given I am a registered consumer
    And I have confirmed my mobile number
    When I go to the consumer profile page
    Then I should be able to choose my preferred way to receive messages from businesses

  Scenario: Updating a Location
    Given I am a registered consumer
    When I go to the consumer profile page
    Then I should be able to update my location

  Scenario: Updating a Mobile number
    Given I am a registered consumer
    When I go to the consumer profile page
    Then I should be able to input my mobile number

  Scenario: Confirming a Mobile number
    Given I am a registered consumer
    When I go to the consumer profile page
    Then I should be able to enter my mobile confirmation code

  Scenario: Resending a mobile confirmation code
    Given I am a registered consumer
    And I am awaiting a mobile confirmation token
    When I go to the consumer profile page
    Then I should be able to request a redelivery of the mobile confirmation token

