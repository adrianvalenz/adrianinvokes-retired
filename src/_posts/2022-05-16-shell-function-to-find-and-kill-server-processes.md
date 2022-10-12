---
layout: post
title: Shell function to find and kill server processes
subtitle: Super quick way to get you back into work mode
date: 2022-05-16 22:44:02 -0700
categories: code
author: adrian
---

<video class="hidden" width="100%" controls autoplay>
    <source src="/videos/listenfor-and-killpid-demo.mov" type="video/mp4">
</video>

Add these neat little functions in your `.zshrc` file and use them to quickly
find what ports are in use and kill them off.

```ruby
listenfor() {
  if [ "$1" != "" ]
  then
    lsof -wni tcp:"$1"
  else
    echo "need to enter a port number (i.e. 3000)"
  fi
}

killpid() {
  if [ "$1" != "" ]
  then
    kill -9 "$1"
  else
    echo "need to enter PID number"
  fi
}
```

Now you can run something like:
`listenfor 3000` and `killpid 71234`.

<div class="tenor-gif-embed" data-postid="15810606" data-share-method="host" data-aspect-ratio="1.40969" data-width="100%"><a href="https://tenor.com/view/disney-moana-youre-welcome-maui-dance-gif-15810606">Disney Moana GIF</a>from <a href="https://tenor.com/search/disney-gifs">Disney GIFs</a></div> <script type="text/javascript" async src="https://tenor.com/embed.js"></script>
