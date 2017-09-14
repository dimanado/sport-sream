Feature: Direct Coupon Campaign
  In order to deliver coupons to targeted groups of consumers
  As a merchant
  I want to send a direct message with a coupon

  Scenario: Creating a Direct Coupon Message
    Given I am a signed in merchant
    When I go to the direct campaign creation page
    Then I should be able to select direct delivery channels
    And I should be able to preview the default message
    And I should be able to target registered consumers
    And I should be able to schedule delivery of the campaign
    And I should see the coupon creator
    And I should see the cost of sending the campaign