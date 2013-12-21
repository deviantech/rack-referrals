Rack::Referrals
=============

Rack::Referrals is a rack middleware that extracts information about the referring website from each request.  Specifically, it parses the HTTP-REFERER header and tells you if the request came from a known search engine (and if so, what the search terms were). It was inspired by the [search_sniffer](https://github.com/squeejee/search_sniffer) plugin, but provides that functionality as a middleware.


Purpose
-------

Ever wanted to know if the user viewing the current page got there via a search engine?  If so, ever wanted to show them a link like "Click here to browse additional widgets related to *[search term*]"?
  
Yeah, this'll help.


Installation
------------

Quick and easy:

    gem install rack-referrals


Example Usage
-------------------------

Just add it to your middleware stack:

    # Rails 3+ App - in config/application.rb
    class Application < Rails::Application
      ...
      config.middleware.use Rack::Referrals
      ...
    end
    
    # Rails 2 App - in config/environment.rb
    Rails::Initializer.run do |config|
      ...
      config.middleware.use "Rack::Referrals"
      ...
    end

Now you can check any request to see what search engine referred it, and if any did, then what search terms were used.

    class ExampleController < ApplicationController
    
      def index
        str = if request.env['referring.search_engine']
          "You're from #{request.env['referring.search_engine']}, " \
          "where you searched: #{request.env['referring.search_terms']}"
        else
          "You're from somewhere boring."
        end
      
        render :text => str
      end
    
    end

Gettin' Fancy
-------------

This knows about a number of search engines by default (Google, Yahoo, Bing, some big Russian ones... check the <code>DEFAULT_ENGINES</code> constant in <code>lib/rack-referrals.rb</code> for the current list).

You can add in support for additional search engines by passing the <code>:additional_engines</code> parameter:

    class Application < Rails::Application
      ...
      config.middleware.use Rack::Referrals.new :additional_engines => {
        :my_engine_name => [/domain_regular_expression/, 'search-term-parameter'],
        :another_name   => [/domain_regular_expression/, 'search-term-parameter'],
      }
      ...
    end
    
You can also just completely clear the default ones and use _only_ those you define with the <code>:engines</code> parameter:

    class Application < Rails::Application
      ...
      config.middleware.use Rack::Referrals.new :engines => {
        :only_engine_i_like => [/domain_regular_expression/, 'search-term-parameter']
      }
      ...
    end

In either case, <code>domain_regular_expression</code> is a regular expression used to identify this search engine, like <code>/^https?:\/\/(www\.)?google.*/</code>, and <code>search-term-parameter</code> is the parameter that the search engine uses to store the user's search (for Google, that's <code>q</code>).