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

## setting up VPS

TODO

* digital ocean
* ubuntu 14.04

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