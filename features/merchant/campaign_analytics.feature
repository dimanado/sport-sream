Feature: Campaign analytics
  In order to harvest information about the success of a campaign
  As a merchant
  I want to view analytics about how consumers are interacting with my campaign

  Scenario: Delivered campaign analytics index
    Given I am a signed in merchant
    And I have delivered an direct campaign
    And I have delivered an indirect campaign
    When I go to the delivered campaigns page
    Then I should see a list of the delivered campaigns

  Scenario: Delivered campaign analytics index navigation
    Given I am a signed in merchant
    And I have delivered an direct campaign
    And I have delivered an indirect campaign
    When I go to the delivered campaigns page
    And click on the delivered campaign
    Then I should be on the campaign statistics page

  Scenario: Delivered Direct Campaign Analytics navigation
    Given I am a signed in merchant
    And I have delivered an direct campaign
    When I go to the delivered campaigns page
    And click on the delivered campaign
    Then I should be on the campaign statistics page

  Scenario: Direct Campaign Analytics
    Given I am a signed in merchant
    And I have delivered an direct campaign
    When I go to the campaign's statistics page
    Then I should see how many people have viewed the coupon
    And I should see how many people have redeemed the coupon
    And I should see the demographic breakdown of users to whom the campaign was delivered

  Scenario: Delivered Indirect Campaign Analytics navigation
    Given I am a signed in merchant
    And I have delivered an indirect campaign
    When I go to the delivered campaigns page
    And click on the delivered campaign
    Then I should be on the campaign statistics page

  Scenario: Indirect Campaign Analytics
    Given I am a signed in merchant
    And I have delivered an indirect campaign
    When I go to the campaign's statistics page
    Then I should see how many people have viewed the coupon
    And I should see how many people have redeemed the coupon
