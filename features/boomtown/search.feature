Feature: search

  Scenario: keyword search
    Given I'm on the home page
     When I search for "King street"
     Then "King street" appears in the filter list
      And there are at least 20 results
      And each result is in Sullivan's Island