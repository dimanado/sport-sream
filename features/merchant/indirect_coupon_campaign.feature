Feature: Indirect Coupon Campaign
  In order to broadcast coupons to consumers
  As a merchant
  I want to send an indirect message with a coupon

  Scenario: Creating an Indirect Coupon Message
    Given I am a signed in merchant
    And I have configured social apis for my business
    When I go to the indirect campaign creation page
    Then I should be able to select indirect delivery channels
    And I should be able to provide message content
    And I should be able to schedule delivery of the campaign
    And I should see the coupon creator
    And I should see the cost of sending the campaign