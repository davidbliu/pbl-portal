# Installing

easy version: use pbl.link/c9

normal version: 
* install postgres
* install elasticsearch
* clone repo `git clone https://github.com/davidbliu/v2-rails.git`
* TODO finish this

# Models

# Sample Project
create a new reports page

__1) add a new route__
* edit `/config/routes.rb`
* add a line to accept get requests
  * `get '/some_path' => 'test#action_name'`
  * this will let you handle requests to `/some_path` in the file `/controllers/test_controller.rb` through the `action_name` method
* add code to handle the route
  * open `/controllers/test_controller.rb`
  * create a new method
```ruby
def action_name
  # do something here
end
```
    
