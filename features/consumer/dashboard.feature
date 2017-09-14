Feature: Consumer Dashboard
  In order see the current deals applicable to me
  As a consumer
  I want to see a combined presentation of all coupons that were either delivered directly to me or broadcast by a chinoki business which matches my configured category interests.

  Scenario: Consumer with no coupons
    Given I am a registered consumer
    When I go to the consumer dashboard
    Then I should see the coupon table

  Scenario: Consumer with coupons
    Given I am a registered consumer
    And I have received some coupons
    When I go to the consumer dashboard
    Then I should see the business' name
    And I should see the coupon expiration dates
    And I should see the coupon's subject
    And I should see a link to view the coupon
