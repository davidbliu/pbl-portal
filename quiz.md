# setup 

create a new model by adding a file into `/app/models` called `test_model.rb`

the file should contain

```ruby
class TestModel
  # blank
end
```

now create these class methods

```ruby
class TestModel
    
    #
    # Go Links
    #
    def self.top_clicked_golink
      # return a golink
    end
    def self.top_n_clicked_golinks(n)
      # return an array of n golinks
    end
    def self.search_golinks(search_term)
      # return search results for term
    end
    def self.most_active_committee(time_since)
      # return committee that has clicked on the most links links since time_since
    end
    def self.get_permitted_golinks(member)
      # return a list of all the golinks this member is allowed to view
    end
    
    #
    # Posts
    #
    def self.most_recent_blogpost
      # return a blogpost
    end
    def self.get_all_announcement_posts
      # return list of blogposts
    end
    
    #
    # Members
    #
    def self.get_committee_and_position(member, semester_name)
      # ex: ['HT', 'chair']
    end
    def is_officer?(member)
      # return true if this member is currently an officer
    end
    
    #
    # Miscellaneous
    #
    def misc_one
      # explain how authentication works on the portal
    end
    def misc_two
      # whats the point of running source setenv.sh
      # identify 3 files where environment variables are used
      # why can't we just hardcode the values of the environment variables there
    end
    
    def misc_three
      # what does current_member do? 
      # how does it work?
      # where is it implemented?
    end
end
```

you can test these by `source setenv.sh`, `rails console`, and running them like `TestModel.method_name(method_parameters)` and checking the result manually

    
