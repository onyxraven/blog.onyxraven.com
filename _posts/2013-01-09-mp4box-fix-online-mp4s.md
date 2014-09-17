---
layout: post
title:  "MP4Box can fix your online-hosted MP4s"
date: 2013-01-09 14:56:00
categories: mp4
external-url: http://gpac.wp.mines-telecom.fr/mp4box/
---

I just discovered MP4Box (available in osx homebrew as well as other places).  It has tools for rearranging your MP4 videos to optimize them for streaming.  We just did this on all our videos, and not only do they start up faster on every device, it fixed some devices that refused to play our videos!

Our magic incantation was simple: ```MP4Box -hint $file```
