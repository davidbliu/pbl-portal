# Berkeley PBL Members Portal V2
[![Build Status](https://travis-ci.org/davidbliu/v2-rails.svg?branch=master)](https://travis-ci.org/davidbliu/v2-rails)

This repo contains code for PBL Links, Blog, Tabling generator, Points, etc

__see the documentation folder for guides__

## Getting set up to develop

if you're using linux, theres a tutorial for ubuntu setup (prod.md) in the documentation folder of this repo

if using mac, here are steps. if using windows, ggrip

__1) Install rvm__

__2) Install postgres__

__3) Install elasticsearch__

__4) Clone repo__

__5) setenv.sh__

__6) finishing touches__

__7) run rails s__


## Understanding models

these are the models/files you should look at for each of the corresponding feature on the portal. Listed as feature: models

__Pablo (IGNORE THESE):__ Boba, BotMember, DefaultMessage, FBMessage, Pokemon, Pablo, Topic

__PBL Links:__ GoLink, GoLinkClick, GoLinkCopy, GoLinkCopyGroup, GoLinkGroup, Group, GroupMember

__Blog:__ Post, Group, GroupMember

__Groups:__ Group, and associated models

__Tabling:__ TablingSlot, TablingSwitchRequest, TablingManager

__Points:__ Event, Member

__Misc:__ Member, Semester, Position

