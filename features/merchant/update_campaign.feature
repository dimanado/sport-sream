Feature: Updating a campaign

  In order to change the verbage of a campaign after it's been created
  As a merchant
  I want the ability to update a campaign

  Scenario: Disabled delivery options
    Given I am a signed in merchant
    And I have configured social apis for my business
    And I have created some campaigns
    When I go to the scheduled campaigns page
    And I click on a direct campaign
    Then the direct delivery channels should be disabled
    When I go to the scheduled campaigns page
    And I click on an indirect campaign
    Then the indirect delivery channels should be disabled
