Feature: search
  Background:
    Given I'm on the home page

  Scenario: keyword search
     When I search for "King street"
     Then "King street" appears in the filter list
      And there are at least 20 results
      And each result is in Sullivan's Island

  @wip
  Scenario: new user saves search
     When I search for "charleston"
      And I click "Save This Search"
      And I complete registration
      And I click "Save This Search"
      And I save the search as "CHS"
     Then I see my "CHS" saved search
      And I have a user account
