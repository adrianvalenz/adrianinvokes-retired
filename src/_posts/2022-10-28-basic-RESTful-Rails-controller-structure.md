---
layout: post
date: 2022-10-28
title: Basic RESTful Rails controller structure
author: adrian
categories: code
published: false
---

Today we are going to go over a basic Rails controller and break down its
methods one by one and discuss the topic a bit more in depth in hopes it brings
insight to some that may be unfamiliar with controllers. It might be helpful if
one has basic understanding or knowledge of MVC, REST, and HTTP methods. 

## What is a controller?

When you type in a URL in the browser that points to a web app, the app seeks
a matching URL in its router. If it finds one, that route will point to a method
in a controller. The controller will run it's method perform an action and/or 
return a view.

Here is a controller for Posts, a common feature you might see in a blog.

```ruby
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        redirect_to @post
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
```

