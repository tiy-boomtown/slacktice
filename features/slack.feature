Feature: Slack

  Scenario: posting a message using the API
    Given I am testbot
     When I send a message to #test
     Then I should see that message on the #test page