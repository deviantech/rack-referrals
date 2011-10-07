Rack/Referrals
=============

Rack/referrals is a rack middleware that extracts information from each request about the referring website.  Specifically, it parses the HTTP-REFERER header and tells you if the request came from a known search engine (and if so, what the search terms were).


Purpose
-------

Ever wanted to know if the page is being viewed by a user who got there via a search engine?  If so, ever wanted to show them a link like "Interested in <search term>? Click here to browse related widgets"? 
  
Yeah, this'll help.


Installation
------------

Quick and easy:

    gem install rack-referrals


Example Usage (Rails 3 App)
-------------------------

Just add it to your middleware stack:

    class Application < Rails::Application
      ...
      config.middleware.use Rack::Referrals
      ...
    end


Getting Fancy
-------------

This knows about a number of search engines by default (Google, Yahoo, Bing, check the <code>DEFAULT_ENGINES</code> constant in <code>lib/rack-referrals.rb</code> for the current list).

You can add on support for additional search engines (by passing the <code>:additional_engines</code> parameter):

    class Application < Rails::Application
      ...
      config.middleware.use Rack::Referrals.new :additional_engines => {
        :my_engine_name => [/domain_regular_expression/, 'search-term-parameter'],
        :another_name => [/domain_regular_expression/, 'search-term-parameter'],
      }
      ...
    end
    
You can also just completely clear the default ones and use _only_ those you define (with the <code>:engines</code> parameter):

    class Application < Rails::Application
      ...
      config.middleware.use Rack::Referrals.new :engines => {
        :only_engine_i_like => [/domain_regular_expression/, 'search-term-parameter']
      }
      ...
    end

In either case, <code>domain_regular_expression</p> is a regular expression used to identify this search engine, like <code>/^https?:\/\/(www\.)?google.*/</code>, and <code>search-term-parameter</code> is the parameter that the search engine uses to store the user's search (for Google, that's <code>q</code>).