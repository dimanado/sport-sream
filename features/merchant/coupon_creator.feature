Feature: A merchant can create a customized coupon

  As a merchant that wants to have customized coupons,
  I want to be able to edit the a bunch of fields
  So that merchants can brand their coupons

  Scenario: Choosing colors of a direct campaign
    Given I am a signed in merchant
    When I go to the direct campaign creation page
    Then I should see the coupon creator

  Scenario: Choosing delivery method of a direct campaign
    Given I am a signed in merchant
    When I go to the direct campaign creation page
    Then I should be able to select direct delivery channels

  Scenario: Choosing colors of an indirect campaign
    Given I am a signed in merchant
    When I go to the indirect campaign creation page
    Then I should see the coupon creator

  Scenario: Choosing delivery method of a indirect campaign
    Given I am a signed in merchant
    And I have configured social apis for my business
    When I go to the indirect campaign creation page
    Then I should be able to select indirect delivery channels
