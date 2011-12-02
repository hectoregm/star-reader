Feature: Star Stream
  As a user with a twitter account
  I want to see my favorites
  So I can read all the good stuff

Scenario: Displays the user stars
  Given I am a star user
  When I go to my stars
  Then I will see my stars

Scenario: Displays a message when there are zero archived stars
  Given I am a star user login with zero archived stars
  When I go to the archive
  Then I will see no archived stars

@javascript
Scenario: Archive a star
  Given I am a star user
  And I go to my stars
  When I click Archive in a star
  Then the star is removed from the stream

@javascript
Scenario: Unarchive an archived star
  Given I am a star user with archived stars
  And I go to the archive
  When I click Unarchive in an archived star
  Then the star is removed from the stream

@javascript
Scenario: Archiving a star moves it to the Archive
  Given I am a star user
  And I go to my stars
  When I click Archive in a star
  Then the star is removed from the stream
  And I go to the archive
  Then that star is shown
