Feature: Consumer coupon sharing
  In order to let other people know about my awesome coupon
  As a consumer
  I want to be able to share indirect coupons

  Scenario: Sharing an indirect coupon
    Given I am viewing an indirect coupon
    Then I should be able to share the coupon

  #Scenario: Sharing an direct coupon
    #Given I am viewing a direct coupon
    #Then I should not be able to share the coupon
