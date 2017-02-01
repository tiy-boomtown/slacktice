Feature: search
  Background:
    Given I'm on the home page

  Scenario: keyword search
     When I search for "King street"
     Then "King street" appears in the filter list
      And there are at least 20 results
      And each result mentions king

   Scenario: new user saves a search
      When I search for "Charleston"
       And I click "Save Search"
       And I complete registration
       And I click "Save Search"
       And I save the search as "CHS"
      Then I see "CHS" in my saved searches
       And I have a user account
       And my agent is located in Charleston

   Scenario: searching user gets squeezed
     When I search for "Charleston"
      And I click on the first property
      And I go back
      And I click on the second property
     Then I see a registration form