# production environment

__high level overview:__

in dev, you install the portal and dependencies on local workstation, then run rails s and visit localhost:3000 and see the server running.

the situation is similar in production. you install the portal and it's dependencies on a VPS, then run rails s and visit THE_IP:SOME_PORT and see the app working. there are some differences, though, namely
* THE_IP is the IP of the VPS (digital ocean). 
* instead of THE_IP, a domain name (namecheap)
* SOME_PORT is usually port 80, the default HTTP port
* copies of the rails app are placed behind a loadbalancer (see `haproxy.cfg`). 
	* for example, having 3 rails servers running on ports 3000, 3001, 3002. 
	* the load balancer runs on port 80, redirecting requests to either 3000, 3001, 3002, depending on which is most available

# convenience stuff (common tasks)

## ssh

```
ssh root@107.170.243.219

pw (ask)
```

## backing up production data

__use pg_dump__

```
pg_dump -h localhost -p 5432 -U postgres v2_development > path_to_dumpfile.dump

pw (ask)
```

to scp it from the VPS to your machine 
```
scp root@107.170.243.219:/path/to/dumpfile /path/to/local/workstation
```


## loading production dumpfile locally

assuming you have the dumpfile copied somwhere locally, this will import those records into your local database copy.
```
psql -h localhost -p 5432 -U postgres v2_development < path_to_dumpfile.dump
```

## random commands
```
RAILS_ENV=production bundle exec rake assets:precompile
```


# set up a VPS running the portal from scratch

here goes...(disclaimer: untested). might require giving your credit card info and spending a couple cents.

__set up a digital ocean account__
* do this here: https://www.digitalocean.com

__create a droplet__

* click 'create droplet'
* pick ubuntu 14.04
* pick the smallest size
* pick san francisco
* if you wanna be secure, tune the security stuff, otherwise keep going

__log into your droplet__

* you should receive an email with instructions for how to do this
* ssh in with the password

__install portal dependencies__

lets start with the basics, which include ruby, git, and cloning the portal

```
# install ruby via rvm
sudo apt-add-repository ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get -y install rvm

# log out and log back in
rvm install ruby

# install git
sudo apt-get -y install git

# clone the portal
git clone https://github.com/davidbliu/v2-rails.git

# install the portal's gems
cd v2-rails
gem install bundler
sudo apt-get -y install libpq-dev # this is so pg gem installs
bundle install

# set up a firewall
sudo apt-get -y install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow www
sudo ufw allow ftp
# if you want you can allow port 3000, for example by 
# sudo ufw allow 3000/tcp
sudo ufw enable
sudo ufw status

# h@ckers should only be able to access your server via ports 20, 21, and 80 now
# you should see this
To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
21/tcp                     ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
21/tcp (v6)                ALLOW       Anywhere (v6)
```


__now lets install postgres__

```
sudo apt-get install -y postgresql postgresql-contrib

# now you'll have to set up your postgres account
sudo -u postgres psql postgres
# you will see a postgres console 
>>> \password postgres
>>> set your password to "password"
>>> \q
```

__last up, elasticsearch__
```
# these instructions are from pbl.link/elasticsearch-install

apt-get -y install openjdk-6-jre
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -y update
sudo apt-get -y install oracle-java7-installer

# careful not to do this from your v2-rails directory
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.tar.gz
tar -xf elasticsearch-0.90.7.tar.gz

# see this link about further setup
pbl.link/elasticsearch-install

# start elasticsearch
cd elasticsearch-0.90.7
./bin/elasticsearch

# test it
curl localhost:9200

# you should see
{
  "ok" : true,
  "status" : 200,
  "name" : "Temugin",
  "version" : {
    "number" : "0.90.7",
    "build_hash" : "36897d07dadcb70886db7f149e645ed3d44eb5f2",
    "build_timestamp" : "2013-11-13T12:06:54Z",
    "build_snapshot" : false,
    "lucene_version" : "4.5.1"
  },
  "tagline" : "You Know, for Search"
}
```

__last up, we need the setenv.sh script__

```
cd v2-rails
touch setenv.sh
# ask for the contents, paste, save the file
```

jk this is not the last step 

__install haproxy, for load balancing__

```
sudo add-apt-repository -y ppa:vbernat/haproxy-1.5
sudo apt-get update
sudo apt-get install -y haproxy
# from just outside the rails directory
cp v2-rails/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo service haproxy restart

# visit YOUR_IP, you should see
# 503 Service Unavailable
# No server is available to handle this request.
```


__finally lets run the portal__

run these from your rails root

```
rake db:create
psql -h localhost -p 5432 -U postgres v2_development < c9.dump
rake db:migrate
source setenv.sh

# start the webservers at ports 3000, 3001, 3002
sh deploy.sh # check the contents of this file to see whats going on
```

YAAY. you should now see the landing page of the portal. if you try other pages like the blog, for example, you'll get a google error. this is because you need to add this IP to our google app. (ask about this)

typically now you'd buy a domain name and point it to YOUR_IP

__what this guide left out__

* setting up google accounts, etc (whats in setenv.sh)
* the contents of setenv.sh are important
	* google account, keys, etc
	* pg_host and pg_port
	* elasticsearch host and port
	* google push api keys, etc
	* read up on google for how to set these up

