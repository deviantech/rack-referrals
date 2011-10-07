require "test/unit"
require "rack/test"

require File.expand_path(File.dirname(__FILE__) + '/../lib/rack-referrals')

class ReferralTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app    
    hello_world_app = lambda do |env|
      [200, {}, "Hello World"]
    end
    
    Rack::Referrals.new(hello_world_app)
  end

  def test_parses_google
    get '/', nil, 'HTTP_REFERER' => "http://www.google.com/search?q=ruby+on+rails&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a" 
    
    assert_equal "google", last_request.env['referring.search_engine']
    assert_equal "ruby on rails", last_request.env['referring.search_phrase']
  end

  def test_handles_missing_params
    get '/', nil, 'HTTP_REFERER' => "http://www.google.com/search?ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a" 
    
    assert_equal "google", last_request.env['referring.search_engine']
    assert_equal nil, last_request.env['referring.search_phrase']
  end

  def test_handles_no_referer
    get '/'
    
    assert_equal nil, last_request.env['referring.search_engine']
    assert_equal nil, last_request.env['referring.search_phrase']
  end


end
