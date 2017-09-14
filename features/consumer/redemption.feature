Feature: A consumer redeems a coupon

  In order to capitalize on a merchant's coupon
  As a consumer
  I want the ability to redeem said coupon

  Scenario: viewing my redemption code
    Given I have received a coupon via SMS
    When I click on the link in the message
    Then I should see my redemption coupon
    And I should see the coupon message
