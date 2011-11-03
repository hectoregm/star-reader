Feature: Dashboard
  As a user with a twitter account
  I want to see my favorites
  So I can read all the good stuff

Scenario: Display favorite tweets
  Given I am a twitter user
  When I go to the dashboard
  Then I will see my favorite tweets
