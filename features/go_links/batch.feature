Feature: Batch edit golinks to quickly place them in groups

Background: golinks have been added to the database

  Given the following golinks exist:
  | key | url | groups |
  | key1 | url1 | g1k |
  | key2 | url2 | g2k |
  | key3 | url3 | g1k,g2k |
  | key4 | url4 | g1k |

  Given the following groups exist:
  | key | name | creator | emails |
  | g1k | g1-name | e1@g | e1@g | 
  | g2k | g2-name | e1@g | e1@g, e2@g |
  | g3k | g3-name | e2@g | e2@g |
  | g4k | g4-name | e2@g | e2@g |

@javascript
Scenario: clicking checkboxes selects golinks
  Given I log in as "e1@g"
  Given I am on the go_menu page
  Given I check the box for "key1"
  And I check the box for "key2"
  
  Given I visit the checked links page
  Then I should see "key1"
  Then I should see "key2"
  Then I should not see "key3"

  Given I uncheck the box for "key2"
  And I visit the checked links page
  Then I should not see "key2"

@javascript
Scenario: editing groups changes their groups
  Given I log in as "e1@g"
  Given I am on the go_menu page
  Given I check the box for "key1"
  And I check the box for "key2"
  And I visit the checked links page
  And I check the box to "add" "g1k"
  And I check the box to "add" "g2k"
  And I click the id "update-groups-btn"

@javascript
Scenario: batch deleting links works
  
