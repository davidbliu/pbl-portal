Feature: golink group sharing correct
 
  I want to see golinks that my groups have access to
  when i remove groups i want the permissions to be correctly updated

Background: golinks have been added to the database

  Given the following golinks exist:
  | key | url | groups |
  | key1 | url1 | g1-key |
  | key2 | url2 | g3-key |
  | key3 | url3 | g1-key,g2-key |

  Given the following groups exist:
  | key | name | emails | 
  | g1-key | g1-name | e1@gmail.com | 
  | g2-key | g2-name | e1@gmail.com, e2@gmail.com |
  | g3-key | g3-name | e2@gmail.com |

Scenario: group permissions work on index page
  Given that I am logged in as "e1@gmail.com"
  Given I am on the go_menu page
  Then I should see "key1"
  Then I should not see "key2"

Scenario: removing a group removes group from golink groups

Scenario: removing a group resets groups to anyone



