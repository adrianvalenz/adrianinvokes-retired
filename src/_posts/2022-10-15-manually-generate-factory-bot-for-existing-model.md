---
layout: post
title: "Manually generate a Factory for a Model after created"
date: 2022-10-15
author: adrian
categories: code
---

If you ever need to create a factory for an existing model, all you have to do
is run the generator.

So if you had an existing `Article` model, and it had attributes such as
`title:string`, `content:text`, and `user:references`, you would run...

```ruby
bin/rails g factory_bot:model Article title:string content:text user:references
```

and it will generate a factory for you ready to use in your tests.
