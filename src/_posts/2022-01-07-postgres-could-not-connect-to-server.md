---
layout: post
title: Postgres could not connect to server
date: 2022-01-07 11:30:00 -0700
subtitle: After brew update/upgrade can't start psql, here's a fix on a mac
categories: code
author: adrian
---

```ruby
rm /usr/local/var/postgres/postmaster.pid
brew services restart postgresql
```

_[source for fix](https://stackoverflow.com/questions/13410686/postgres-could-not-connect-to-server)_
