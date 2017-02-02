Feature: related properties

  Scenario: for very expensive properties
    When I look at an expensive property
    Then I should see at least 3 related properties