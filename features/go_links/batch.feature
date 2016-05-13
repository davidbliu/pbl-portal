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

Scenario: deselecting links works

Scenario: editing groups works
  
