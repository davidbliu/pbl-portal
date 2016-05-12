Feature: Batch edit golinks to quickly place them in groups

Background: golinks have been added to the database

  Given the following groups exist:
  | name | creator | emails |
  | g1 | e1@gmail.com | e1@gmail.com | 
  | g2 | e1@gmail.com | e1@gmail.com |
  | g3 | e2@gmail.com | e1@gmail.com |
  | g4 | e2@gmail.com | e1@gmail.com |
  | g5 | e2@gmail.com | e1@gmail.com |

  Given the following golinks exist:
  | key | url | groups |
  | key1 | url1 | g1 |
  | key2 | url2 | g1 |
  | key3 | url3 | g1 |
  | key4 | url4 | g1 |

Scenario: clicking checkboxes selects golinks
  Given I log in as "e1@gmail.com"
  Given I am on the go_menu page
  Given I check the box for "key1"
  And I check the box for "key2"
  
  Given I visit the checked links page
  Then I should see "key1"
  Then I should see "key2"
  Then I should not see "key4"

  Given I uncheck the box for "key2"
  And I visit the checked links page
  Then I should not see "key2"

Scenario: deselecting links works

Scenario: editing groups works
  
