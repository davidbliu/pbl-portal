Feature: I want to be able to save some preferences so I can use golinks more efficiently

Background: golinks have been added to the database
	Given the following golinks exist:
	  | key | url | groups |
	  | key1 | url1 | g1k |
	  | key2 | url2 | g2k |
	  | key3 | url3 | g1k,g2k |
	  | key4 | url4 | g3k |

	Given the following groups exist:
	  | key | name | creator | emails |
	  | g1k | g1n | e1@g | e1@g | 
	  | g2k | g2n | e1@g | e1@g,e2@g |
	  | g3k | g3n | e2@g | e2@g |
	  | g4k | g4n | e2@g | e2@g |

Scenario: preferences page is editable
	Given I am logged in as "e1@g"
	Given I am on the go_preferences page
	Given I check the default box for "g1k"
	Given I save my preferences
	Given I add a link: "new-key" "http://google.com"
	Given I am on the go_menu page
	Then I should see "new-key"