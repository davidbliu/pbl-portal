# Installing

easy version: use pbl.link/c9

normal version (for mac): 
* install postgres
* install elasticsearch
* clone repo `git clone https://github.com/davidbliu/v2-rails.git`
* TODO finish this

windows version (gg rip). easiest way is to install a virtual machine running linux and follow the prod environment steps (see `prod.md`)

# Models
see `/db/schema.rb`

__Member, Position__

* pretty self explanatory
* email is a foreign key in many tables
  * email because used to store member_id. this would break when we remove/change members. happened often enough that it was annoying. 
  * email uniquely identifies members anyway
* member stores current position
  * this is just because convenient
  * position should be viewed as the source of truth for member positions

__GoLink, GoLinkClick__

* golinks are for PBL Links
* `pbl.link/{{key}}` redirects to `url`
* there can be multiple keys with same name, in which case user sees a landing page with all options listed
* GoLinkClicks are used to track page views
  * __note:__ this may change
  * see the blog_controller index view for how tihs works, for example

__Event__

* purpose of events (currently) is just for tracking points
* list of people who attended and who didnt
  * this is so you have to respond either yes i went or no i didn't
  * instead of default no: in which case you can't tell who just forgot to mark their attendance

__TablingSlot, TablingManager__

* tabling manager has tabling algorithm implementation
* commitments is a field in the member table
  * it is an array of times that the member is free
  * times are between 0..167 (24 hours * 7 days = 168 hours per week)

__Post__

* self explanatory, see `schema.rb`

__Mailers__

* currently only blog_mailer
* sends blog emails 
* see `send_mail` method in `/app/models/post.rb`


# How to play around with stuff
* before doing anything, you must run `source setenv.sh`. this sets environment variables
* running `rails console` lets you test out commands in a REPL
* try `rails s` and visiting localhost:3000

## making changes
when you're ready to make changes (ie starting the sample project) __dont do it on the master branch__
* `git checkout -b name_of_branch`
* make your changes

# the dev process

TODO: decide formal process for this

* should developers be added to repo
* set up private repo
* have tests, only accept pushes that pass tests
* fork, pull request


# Sample Project
create a new reports page

__1) add a new route__
* edit `/config/routes.rb`
* add a line to accept get requests
  * `get '/some_path' => 'test#action_name'`
  * this will let you handle requests to `/some_path` in the file `/app/controllers/test_controller.rb` through the `action_name` method
__2) add code to handle the route in a controller__
* open `/app/controllers/test_controller.rb`
* create a new method
```ruby
def action_name
  # do something here
end
```
__3) create a view__
* add a file to `/app/views/test` with the same name as your action_name
  * ex: `/app/views/test/action_name.html.erb`
* add some html to this file
```html
<h1>New Page</h1>
<div>hi</div>
```
__4) do some reporting__

some things you could consider creating reports for are

1. top viewed blogposts
2. top viewed golinks
3. most active members on pbl links
4. highlight members who haven't marked their attendance

each of these tasks will expose you to different models. you'll get to learn how data is stored in the portal.

we'll walk through __1. top viewed blogposts__

## show top viewed blogposts

__1) add a class method to the `Post` model to get the top viewed blogposts__

* open `/app/models/post.rb`
* add a method `self.top_viewed_posts`
  * later we will call this as `Post.top_viewed_posts`

we want this method to take in a time (time_since) and return a dictionary from post id to num clicks.
```ruby
def self.top_viewed_posts(time_since)
  # do some calculation
  # return a dictionary
end
```
the dictionary should look something like this
```
{
  1: 13,
  2: 0,
  3: 56,
  4: 77
}
```
this means post 1 had 13 views, post 2 had 0 views, etc.

__2) implement the method__
try to understand this code
```ruby
def self.top_viewed_posts(time_since)
  views_hash = {}
  Post.each do |p|
   num_clicks = GoLinkClick.where('created_at > ?', time_since)
     .where(golink_id: 'blog_id')
     .where(key: "/blog/post/#{p.id}:#{p.title}")
     .length
   views_hash[p.id] = num_cliks
  end
  return views_hash
end
```
__3) expose these results to your view__

lets go back to the `action_name` method we created in `/app/controllers/test_controller.rb`. we want to bind the results of top_viewed_posts to a variable our view can use

```ruby
def action_name
  @time_since = Time.now - 1.week
  @top_posts = Post.top_viewed_posts(@time_since)
  @posts = Post.where('id in (?)', @top_posts.keys)
end
```

__4) make it pretty in the view__

lets display it in the view in the most ugly, jank way possible. edit `/app/views/test/some_action.html.erb`
```html
<h1>Top Viewed Blogposts since <%= @time_since %></h1>
<% @posts.each do |post| %>
  <div>
    <%= post.title %>: <%= @top_posts[post.id] %> clicks
  </div>
<% end %>
```

__5) done__

some good next steps are
* try more reports
* make them prettier (graphs, d3, etc)

when you are comfortable with grabbing data and displaying it, move on to creating new models/features on the website.
  


    
