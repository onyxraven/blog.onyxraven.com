---
layout: post
title:  "Protocols in Ruby"
date: 2014-11-18 9:30:00
categories: ruby rubyconf
---

In the RubyConf keynote, Matz discussed concerns about leaving behind duck typing for static typing or type hinting.

To formalize the idea of keeping ruby ruby with duck typing, but adding more formalization of sets of methods, propose Protocols

```ruby
module MyProtocol #protocol MyProtocol
  include Protocol

  reqdef required_fn
  reqdef another_required_fn
end

class MyClass
  #stuff... unless theres an after class 'include'
  #protocol MyProtocol

  def required_fn; end
  def another_required_fn; end

  include MyProtocol
end

class BrokenClass
  #protocol MyProtocol
  include MyProtocol
end #Raises ProtocolError
```

