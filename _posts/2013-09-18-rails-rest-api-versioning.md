---
layout: post
title:  "Rails REST API versioning"
date: 2013-09-18 15:39:00
categories: ruby rails routing
---

There have been a few other articles regarding versioning REST APIs in Rails.  Many reference [this RailsCasts (#350)](http://railscasts.com/episodes/350-rest-api-versioning) to set up header based versioning, and there have been a few setting up path based versioning using the 'namespace' feature in Rails 3 routing.

Our API was set up with path based using routing namespaces, and we moved ahead happily with v1.

```ruby
namespace :v1 do
  resource :ping
end

class Api::V1::PingController ...
end
```
```
GET http://example.org/v1/ping
```

Recently we started working on v2 features, and started in a new namespace, looking just like v1.  To make it easy on our apps, we wanted to make all the API calls against the v2 api, even on controllers that didn't get an 'upgrade' into the v2 namespace.

```
http://example.org/v1/ping
http://example.org/v2/ping #fallback to the v1
http://example.org/v2/pong #use v2 namespace
```

This is a non-obvious operation.  In most REST cases, redirects like explained in [this StackOverflow post](http://stackoverflow.com/questions/9627546/api-versioning-for-rails-routes/9627796#9627796) are not possible because you shouldn't redirect POSTs (technically an HTTP 301 response should work, but there are few HTTP clients that respect that strict mode.  If you don't believe a 301 response to a POST should result in a new POST, read [the spec](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html) carefully).

[Josh Symonds](http://joshsymonds.com/) talks about how [existing API solutions are terrible](http://joshsymonds.com/blog/2013/02/22/existing-rails-api-solutions-suck/), and really only one of the gems Symonds talks about in his post handles 'fallback' apis: [rocket_pants](https://github.com/filtersquad/rocket_pants).  I wasn't keen on using the whole kit of rocket_pants features, so I looked into [how the 'api' method works](https://github.com/filtersquad/rocket_pants/blob/master/lib/rocket_pants/routing.rb).  Its just a fancy wrapper around a 'scope' line.

Taking a cue from that, I came up with the replacement for the 'namespace' lines:

```ruby
scope :module => 'v2', :path => ':api_version', :constraints => { :api_version => /v2/ } do
   resource :pong
end

scope :module => 'v1', :path => ':api_version', :constraints => { :api_version => /v[12]/ } do
  resource :ping
end
```

A few notes about the scope line:

* specs/tests that test 'route_to' assertions will need to respect the fact that :api_version will be included in the list of route parameters
* regex against paths cannot be anchored.  It throws an exception at app startup time (which Passenger may hide), because those regexes are already anchored, and really you're only working on one piece of the path at a time.
* Order matters in routing - it is evaluated top-down so pay attention to the fallbacks.

Now, in the v2 scope, we can also override a given resource with a controller from the new namespace, since it will match first.
