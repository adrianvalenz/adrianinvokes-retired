---
layout: post
title: Display current year with a little bit of JavaScript
date: 2022-01-07 11:44:00
categories: code
author: adrian
---

In your JavaScript file...

```ruby
document.getElementById("year").innerHTML = new Date().getFullYear();
```

Then in your HTML...

```ruby
<span id="year" class="your-styles"></span>
```
