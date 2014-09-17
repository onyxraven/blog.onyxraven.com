---
layout: post
title:  "Local/Server synchronization with Ruby and FSEvent"
date: 2011-10-02 09:12:00
categories: ruby osx rsync
---

A lot of the work I do is PHP/html type coding. I try to keep a local setup that is able to run all of my code without too much trouble, but eventually all that code has to be tested on something resembling the production environment, or there are certain functions that can only be performed there (say, handling NFS mounts, or attaching to databases otherwise firewalled on my local machine). In those situations, I need to be able to quickly copy my code from my local machine to the development server. I used to do this manually, but the cycle of edit-save-copy-test was really annoying. Aptana and Eclipse have some tools that help, but I don't use those tools anymore day-to-day, and they seemed to always get messed up.

I took while to find a suitable setup for keeping files in sync like this. Somehow I came across doubledown, a ruby script using the OSX FSEvent framework. For whatever reason, I couldn't quite make it work on my machine (YMMV), so I took the idea and searched for other uses of FSEvent out there. I came across a few rubygems wrapping FSEvent nicely, and wrote a script around that. First, you'll probably want to set up ssh keys. This will let you rsync over ssh without having to log in every time (kind of important on this one). I don't like the idea of having keys that don't have a password, so I use keychain to manage my keys. In my ~/.zshrc I have the following snippet:

{% gist 4366205 %}

The random delay lets me launch more than one shell at a time (my default windowgroup in Terminal.app is has two) without conflict.

Second, you'll want to have a way to fully-sync your directories. The following script does this with a single command, and with some options provided by gnu getopt. The biggest features are a preset source/destination (which can be appended), and skipping .svn/.hg directories. In a rush, skipping those makes a HUGE speed difference (especially when skipping svn).

{% gist 4366220 %}

Now for the actual ruby script using FSEvent. It also includes using growl to notify on synchronization events. While not required, it is nice to know when things are synched (and it lets me know the script is still running), but it can get a bit spammy (especially running svn up on a directory).

{% gist 4366239 %}

These scripts aren't perfect, and are meant to be modified to your own needs and preferences. Its so nice not to have to worry about manually syncing the directories anymore though!
