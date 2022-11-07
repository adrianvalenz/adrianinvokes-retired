---
layout: post
title: Setting up a Bridgetown Blog with Prismic Headless CMS
categories: code
author: adrian
---

Log into your Prismic account and set up a repo by clicking "With another framework" option and you'll arrive at a screen where you enter your repo name which will act as a your subdomain (yoursite.prismic.io)

<img src="/images/brismic/br-newrepo.png"/>

Give it a display name and select "Other" from the dropdown asking "Which technology do you plan to use in your repository?"...they don't know how to spell "Bridgetown" but that's ok...🤷🏻‍♂️

<img src="/images/brismic/br-choosetech.png"/>

At the root of your project run `bin/bridgetown apply https://github.com/bridgetownrb/bridgetown-prismic`. The script will run bundle and install the gem, create a starter model, and append to your `bridgetown.config.yml`. 

Open up `bridgetown.config.yml` and add your subdomain to configure your Prismic repo. So for Antonio it will look like this: `prismic_repository: italianbistro.prismic.io`. 

Let's enable the bridgetown_ssr plugin in our `server/roda_app.rb` file.

```ruby
class RodaApp < Bridgetown::Rack::Roda
  plugin :bridgetown_ssr # and don't forget this

  route do |r|
	  r.bridgetown
  end
end
```

Let's add `init :"bridgetown-prismic"` to the `config/initializers.rb` to load the plugin.

The plugin generated a model file for us, and it added a field for featured_image so we'll just add that to our view right now.

Open up `src/_layouts/post.liquid` and add `{{ data.featured_image }}` in your template.

Let's create a `render.yaml` and drop this in it or similar.

```ruby
services:
  - type: web
    name: italianbistro
    env: ruby
    repo: https://github.com/adrianvalenz/italianbistro
    buildCommand: bundle install && yarn install && bin/bridgetown frontend:build
    startCommand: bin/bridgetown start
    envVars:
      - key: BRIDGETOWN_ENV
        value: production
```

Go to your Render dashboard and create a "New Blueprint Instance" and select your repo. It'll ask me to name my "Service Group Name" so I'll just name it "Bridgetown Apps". Everything should be set up so click "Apply" and go for it. 

<img src="/images/brismic/br-newblueprint.png"/>

> Note: Your deploy might fail initially if it's your first time using Render. When I came across the issue my fix was to update the lockfile and add your platform as suggested in the logs and disconnected initial blueprint instance and just tried again.


<img src="/images/brismic/br-addplatform.png"/>

It should start deploying...and we're live!

<img src="/images/brismic/br-sitelive.png"/>


Make a webhook so any published content will trigger rebuild of your site.

<img src="/images/brismic/br-webhook.png"/>


You can find your Deploy Hook URL in your Render settings for your specific service. Leave "Secret" blank.

<img src="/images/brismic/br-deployhook.png"/>


In our model file you'll find the Prismic custom type which is also our API ID. Go ahead and create a repeatable type.

```ruby
def prismic_custom_type = :blog_post
```

<img src="/images/brismic/br-repeatabletype.png"/>

Start dragging your fields that you want to 

<img src="/images/brismic/br-draggable.png"/>

After you have added all your fields, save it and go to your documents to add your first blog post.

After you write your first post go ahead and save then publish. This should trigger a site rebuild and once it deploys your new article will show up online.

### Making a model for pages

Making pages work is a little trickier but it really just means we need to tweak the Page model and set some defaults in Bridgetown's configuration file.

Make a `models/page.rb` file and add the following...

```ruby
class Page < Bridgetown::Model::Base
  class << self
    def collection_name = :pages
    def prismic_custom_type = :page
    def prismic_slug(doc) = doc.slug
    def prismic_url(doc)
      "/#{prismic_slug(doc)}"
    end
  end

  def self.process_prismic_document(doc)
    provide_data do
      id                doc.id
      slug from: ->     { prismic_slug(doc) }
      type              doc.type
      created_at        doc.first_publication_date

      layout            :page
      title             doc["page.title"]           .as_text
      content           doc["page.page_body"]       &.as_html with_links
    end
  end
end

```

"Pages" is already a built-in Bridgetown collection so we'll update the `collection_name` to that. We created a custom type in our Prismic dashboard and simple named it "page" so we'll point to it with a symbol. For our Prismic url we want it to just be the slug of the document which will simple by the title of the of page and we'll ensure that is the case by adding to our `bridgetown.config.yml`

```ruby
collections:
  pages:
    output: true
    permalink: /:slug/
```

To keep things simple I just configured a title and content area and I created the 1:1 mappings in my Prismic dashboard. After deploying I created my page and was able to visit it with the expected slug as the URL.

### Creating a homepage model

Start by creating a new single type for the homepage.
<img src="/images/brismic/br-singletype.png"/>

> Question: Difference between "single" and "repeatable" There are two categories of Custom Types: Repeatable Types and Single Types. Repeatable types are for content that you will have more than one, such as articles, products, places, and authors. Single Types are for content you only need one instance of, such as a homepage or a privacy policy page. You can only create one instance of a Single Type. you can choose any page to be a single type it can still be a Bridgetown Pages collection. I thought I'd throw that out there because collections could be synonymous with repeatable types.

Back in your project folder let's create a new model for the homepage as well

```ruby
class Homepage < Bridgetown::Model::Base
  class << self
    def collection_name = :pages
    def prismic_custom_type = :homepage
    def prismic_slug(doc) = doc.slug
    def prismic_url(doc)
      "/#{prismic_slug(doc)}"
    end
  end

  def self.process_prismic_document(doc)
    provide_data do
      id              doc.id
      slug from: ->   { prismic_slug(doc) }
      type            doc.type
      created_at      doc.first_publication_date

      layout          :home
      title           doc["homepage.title"]       .as_text
      permalink       doc["homepage.permalink"]   &.as_text
      page_class      doc["homepage.page_class"]  &.as_text
      content         doc["homepage.body"]        &.as_html with_links
    end
  end
end
```

The homepage is still part of the "Pages" collection so we need to define that. This model is a bit different in that we need to  create a `permalink` field and map it our variable in our model. This will allow us to have control of the url for the homepage so it indeed shows up on the root path. I added a new variable called `page_class` which is found in the `default.liquid` layout template and it allows you to add a custom CSS class to each page or post if you wanted to. You can add it to the Page and Post models and it will work just as well.
