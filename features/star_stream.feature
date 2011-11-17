Feature: Star Stream
  As a user with a twitter account
  I want to see my favorites
  So I can read all the good stuff

Scenario: Displays the user favorites
  Given I am a star user
  When I go to my favorites
  Then I will see my favorites

Scenario: Displays a message when there are zero archived favorites
  Given I am a star user login with zero archived favorites
  When I go to the archive
  Then I will see no archived favorites

@javascript
Scenario: Archive a favorite
  Given I am a star user
  And I go to my favorites
  When I click Archive in a favorite
  Then the favorite is removed from the stream

@javascript
Scenario: Unarchive an archived favorite
  Given I am a star user with archived favorites
  And I go to the archive
  When I click Unarchive in an archived favorite
  Then the favorite is removed from the stream

@javascript
Scenario: Archiving a favorite moves it to the Archive
  Given I am a star user
  And I go to my favorites
  When I click Archive in a favorite
  Then the favorite is removed from the stream
  And I go to the archive
  Then that favorite is shown
