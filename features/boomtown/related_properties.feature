Feature: related properties

  Scenario: for very expensive properties
    Given I'm on the home page
     When I look at an expensive property
     Then I should see at least 3 related properties