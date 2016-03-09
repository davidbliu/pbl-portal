# setup 

create a new model by adding a file into `/app/models` called `test_model.rb`

the file should contain

```ruby
class TestModel
  # blank
end
```

new create these class methods

```ruby
class TestModel
    def self.top_clicked_golink
      # return a golink
    end
    def self.top_n_clicked_golinks(n)
      # return an array of n golinks
    end
    def self.most_recent_blogpost
      # return a blogpost
    end
```

you can test these by `source setenv.sh`, `rails console`, and running them like `TestModel.method_name(method_parameters)` and checking the result manually

    
