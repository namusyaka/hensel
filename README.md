# Hensel

[![Build Status](https://travis-ci.org/namusyaka/hensel.svg)](https://travis-ci.org/namusyaka/hensel)
  
Hensel makes it easy to build the breadcrumbs.

Especially, want to recommend for use in Sinatra and Padrino.
    
## Installation 
        
Add this line to your application's Gemfile:

    gem 'hensel'

And then execute:
    
    $ bundle
    
Or install it yourself as:
    
    $ gem install hensel

## Requirements

* MRI 2.0+
    
## Overview

Hensel can be used easily in your web applications, and it has powerful flexibility.
You can use it as helper and builder.
In the next section, will explain in detail how to use them.

## Usage
      
### Configuration
      
```ruby
require 'hensel'
    
Hensel.configure do |config|
  # Default values
  config.bootstrap      = false
  config.escape_html    = true
  config.indentation    = true
  config.last_item_link = false
  config.richsnippet    = :microdata
  config.attr_wrapper   = "'"
  config.whitespace     = "  "
  config.parent_element = :ul
end
```

**If `bootstrap` is set to `true`, the parent element of breadcrumbs will contain `breadcrumb` as class attrbiute, and the last item will contain `active` as class attrbiute as well.**
It will be something like below.

```html
<ul class='breadcrumb'>
  <li>
    <a href='/'>
      index
    </a>
  </li>
  <li class='active'>
    current
  </li>
</ul>
```

**If `escape_html` is set to `true`, the text of item and all value of attributes will be escaped.**

**If `indentation` is set to `true`, the breadcrumbs will be indented.**

**If `richsnippet` is set to correct symbol, the breadcrumbs will follow the rules of the rich snippets that have been specified.**
There is a `:microdata` and `:rdfa`, please specify `nil` if not required type.
It will be something like below.

```html
<!-- microdata -->
<ul>
  <li itemscope itemtype='http://data-vocabulary.org/Breadcrumb'>
    <a href='/' itemprop='url'>
      <span itemprop='title'>
        index
      </span>
    </a>
  </li>
  <li itemscope itemtype='http://data-vocabulary.org/Breadcrumb'>
    <span itemprop='title'>
      current
    </span>
  </li>
</ul>

<!-- RDFa -->
<ul xmlns:v='http://rdf.data-vocabulary.org/#'>
  <li typeof='v:Breadcrumb'>
    <a href='/' rel='v:url' property="v:title">
      index
    </a>
  </li>
  <li typeof='v:Breadcrumb'>
    <span property="v:title">
      current
    </span>
  </li>
</ul>
```

*If don't have special reason, you should enable the option.*
*Microdata and RDFa are supported by [google](https://support.google.com/webmasters/answer/185417?hl=en).*


**If `last_item_link` is set to `true`, the link of the last item will contain `a` element as with other elements.**
It will be something below.

```html
<!-- If `last_item_link` is set to `true` -->
<ul class="breadcrumb">
  <li>
    <a href="/">
      index
    </a>
  </li>
  <li>
    <a href="/foo">
      foo
    </a>
  </li>
</ul>
<!-- If `last_item_link` is set to `false` -->
<ul class="breadcrumb">
  <li>
    <a href="/">
      index
    </a>
  </li>
  <li>
    <span>
      foo
    </span>
  </li>
</ul>
```


**If `attr_wrapper` is set to a wrapper string, all attributes will be used it as the attribute wrapper.**
It will be somthing below.

```html
<!-- If `attr_wrapper` is set to `'"'` -->
<ul class="breadcrumb">
  <li>
    <a href="/">
      index
    </a>
  </li>
</ul>
<!-- If `attr_wrapper` is set to `nil` -->
<ul class=breadcrumb>
  <li>
    <a href=/>
      index
    </a>
  </li>
</ul>
```

**If `whitespace` is set to a whitespace string, all indentation will be used it as the indentation space.**
It will be somthing below.

```html
<!-- If `whitespace` is set to `" "` -->
<ul>
 <li>
  <a href="/">
   index
  </a>
 </li>
</ul>
<!-- If `attr_wrapper` is set to `"    "` -->
<ul>
    <li>
        <a href="/">
            index
        </a>
    </li>
</ul>
```

**If `parent_element` is set to a name string, it will be used as a name of the parent element.**

### Builder

#### `add(text, url, **options) -> Hensel::Builder::Item`

Adds a new item to items, and returns a fresh instance of `Hensel::Builder::Item` built by the builder.

```ruby
builder = Hensel::Builder.new
item = builder.add("home", "/")
item.text #=> "home"
item.url #=> "/"
```

#### `add(**parameters) -> Hensel::Builder::Item`

```ruby
builder = Hensel::Builder.new
item = builder.add(text: "home", url: "/")
item.text #=> "home"
item.url #=> "/"
```

#### `remove(text)`

Removes the item from items.

```ruby
builder = Hensel::Builder.new
builder.add(text: "home", url: "/")

builder.items.empty? #=> false
builder.remove("home")
builder.items.empty? #=> true
```

#### `remove{|item| ... }`

```ruby
builder = Hensel::Builder.new
builder.add(text: "home", url: "/")

builder.items.empty? #=> false
builder.remove{|item| item.text == "home" }
builder.items.empty? #=> true
```

#### `render -> String`

Renders the breadcrumbs, and returns the html of breadcrumbs rendered by this method.

```ruby
builder = Hensel::Builder.new
builder.add(text: "home", url: "/")

builder.render #=> "<ul> ... </ul>"
```

#### `render{ ... } -> String`

This method is for customize breadcrumbs.

If this method has a parameter, it will be an instance of `Hensel::Builder::Item`.

If this method does not have parameter, the block will be evaluated as an instance of `Hensel::Builder::Item`.

However, if you use `render` with block, a few configuration(`richsnippets`, `last_item_link`) will be ignored.

```ruby
builder = Hensel::Builder.new
builder.add(text: "home", url: "/")

builder.render {|item| "<li>#{item.text}</li>" } #=> "<ul><li>home</li></ul>"
builder.render do
  if last?
    node(:li) do
      node(:span){ item.text }
    end
  else
    node(:li) do
      node(:a, href: item.url) do
        node(:span){ item.text }
      end
    end
  end
end
```

### Helpers

The helper is prepared for use in Sinatra and Padrino.

### with Sinatra

```ruby
class Sample < Sinatra::Base
  helpers Hensel::Helpers

  configure do
    Hensel.configure do |config|
      config.attr_wrapper = '"'
      config.whitespace   = '  '
    end
  end

  get "/" do
    breadcrumbs.add("home", "/")
    breadcrumbs.render
  end
end
```

### with Padrino

```ruby
# config/boot.rb
Padrino.before_load do
  Hensel.configure do |config|
    config.attr_wrapper = '"'
    config.whitespace   = '  '
  end
end
```

```ruby
class Sample < Padrino::Application
  helpers Hensel::Helpers

  get :index do
    breadcrumbs.add("home", ?/)
    breadcrumbs.render
  end
end
```

## TODO

* Support Rails
* New syntax for Sinatra and Padrino

## Contributing

1. Fork it ( https://github.com/namusyaka/hensel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
