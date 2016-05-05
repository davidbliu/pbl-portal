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
