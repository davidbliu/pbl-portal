Feature: golink group sharing correct
 
  I want to see golinks that my groups have access to
  when i remove groups i want the permissions to be correctly updated

Background: golinks have been added to the database

  Given the following groups exist:
  | name | creator | emails |
  | g1 | e1@gmail.com | e1@gmail.com | 
  | g2 | e1@gmail.com | e2@gmail.com |
  | g3 | e2@gmail.com | e2@gmail.com |
  | g4 | e2@gmail.com | e2@gmail.com |
  | g5 | e2@gmail.com | e2@gmail.com |

  Given the following golinks exist:
  | key | url | groups |
  | key1 | url1 | g1 |
  | key2 | url2 | g2 |
  | key3 | url3 | g1 |
  | key4 | url4 | g1 |

  
  Given I log in as "e1@gmail.com"

Scenario: adding group works
  Given I am on the groups_new page
  Given I fill out group name with "g6"
  Given I save the group
  Then there should be "6" groups
  Then I should see "g6"
  
Scenario: can edit groups
  Given I edit group "g1"
  Given I fill out group name with "asdf"
  Given I save the group
  Then there should be "5" groups
  Then I should not see "g1"
  Given I am on the go_menu page
  Then I should see "asdf"

Scenario: group permissions work
  Given I log in as "e1@gmail.com"
  Given I am on the go_menu page
  Then I should see "key1"
  Then I should not see "key2"
  Given I log in as "e2@gmail.com"
  Given I am on the go_menu page
  Then I should see "key2"
  Then I should not see "key1"

Scenario: open groups work
  Given I make group "g2" open
  Given I am on the go_menu page
  Then I should see "key2"



  


