Feature: Slack

  Scenario: posting a message using the API
    Given I am testbot
     When I send "hello world" to #test
     Then I should see "hello world" on the #test page