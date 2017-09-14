Feature: A merchant can redeem a consumers coupon

  As a merchant who has sent out a coupon campaign
  I want to check the validity of a consumers coupon
  So that I can make sure they are not trying to scam me

  Scenario: I can verify that a coupon is valid and redeemable
    Given a consumer has received my coupon and presents it to me
    When I go to the coupon redemption page
    And I supply the redemption code of the coupon
    Then I should see that it is valid
    And I should see for which campaign was the coupon
