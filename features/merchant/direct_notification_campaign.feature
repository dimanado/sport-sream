Feature: Direct Notification Campaign
  In order to inform my customer base of happenings
  As a merchant
  I want to send a message to a targeted group of users

  Scenario: Creating a Direct Notification Message
    Given I am a signed in merchant
    When I go to the new direct notification page
    Then I should be able to select direct delivery channels
    And I should be able to provide message content
    And I should be able to target registered consumers
    And I should be able to schedule delivery of the campaign
    And I should not be able to create a coupon
    And I should see the cost of sending the campaign