# Berkeley PBL Members Portal V2
[![Build Status](https://travis-ci.org/davidbliu/PBL-Members-Portal.svg?branch=master)](https://travis-ci.org/davidbliu/PBL-Members-Portal)

This repo contains code for PBL Links, Blog, Tabling generator, Points, etc

__see the documentation folder for guides__

## Description of features

__PBL Links:__ custom url shortener and internal search engine. Ideally any PBL Resource will be findable via PBL Links, allowing members to simply remember what they're looking for and not how to find it. Uses Groups for access control.

__Groups:__ groups are the means of access control for PBL Links and the blog. Add emails to groups (ex: Fall 2014 Officers: davidbliu@gmail.com, etc...), then set Links or Posts to belong to one or more groups. If you belong to any of the groups the link or post belongs to, you can view it.

__Blog:__ a collection of posts. PBL uses its blog like a bulletin board of recent/upcoming events and announcements

__Tabling:__ generates a tabling slot for each member each week. Algorithm tries to place officer in each slot (with special emphasis for first and last slot of day). uses commitments to avoid time conflicts.

__Points:__ points are awarded for attending events. Events have points (pbl.link/points-sheet) and members mark if they attended or did not attend events. 

__Pusher/BlogMailer:__ sends out two types of notifications: push notifications and emails. Currently both types are sent out for blogposts only...

__Chrome Extension:__ allows easy creation of PBL Links. also sets the groundwork for receiving push notifications. repo here: [pbl.link/extension-git](https://github.com/davidbliu/pbl-link-extension#installation)

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

## Reading list and related projects

__Chrome extension:__ pbl.link/extension-git, pbl.link/extension

__Oauth__

__Elasticsearch__

## Contact

David Liu: davidbliu@gmail.com

