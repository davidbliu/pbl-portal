Feature: I want to be able to restore deleted golinks

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
Scenario: deleted links show up in trash
	Given I log in as "e1@g"
	Given I am on the go_menu page
	Given I check the box for "key1"
	Given I check the box for "key2"
	And I delete checked links

	Given I am on the go_trash page
	Then I should see "key1"
	And I should see "key2"
	And I should not see "key3"

@javascript
Scenario: trash permissions work
  Given I log in as "e1@g"
  Given I am on the go_menu page
  Given I check the box for "key1"
  Given I check the box for "key2"
  And I delete checked links

  Given I am on the go_trash page
  Then I should see "key1"
  And I should see "key2"

@javascript
Scenario: can restore links from trash
  Given I log in as "e1@g"
  Given I am on the go_menu page
  Given I check the box for "key1"
  Given I delete checked links
  Given I am on the go_menu page
  Then I should not see "key1"

  Given I am on the go_trash page
  And I restore "key1"
  And I am on the go_menu page
  Then I should see "key1"

Scenario: can discard links from trash