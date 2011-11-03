Feature: Star Stream
  As a user with a twitter account
  I want to see my favorites
  So I can read all the good stuff

Scenario: Display user favorites
  Given I am a star user
  When I go to my favorites
  Then I will see my favorites
