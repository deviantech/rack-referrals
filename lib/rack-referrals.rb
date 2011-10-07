require "rack-referrals/version"

module Rack
  
  #
  # Rack Middleware for extracting information from the HTTP-REFERER header.
  # Specifically, it populates +env['referring.search_engine']+ and 
  # +env['referring.search_phrase']+ if it detects a request came from a known 
  # search engine.
  #
  class Referrals
    
    DEFAULT_ENGINES = {
      # Tested myself
      :google     => [/^https?:\/\/(www\.)?google.*/, 'q'],
      :yahoo      => [/^https?:\/\/([^\.]+.)?search\.yahoo.*/, 'p'],
      :bing       => [/^https?:\/\/search\.bing.*/, 'q'],
      :biadu      => [/^https?:\/\/(www\.)?baidu.*/, 'wd'],
      :rambler    => [/^https?:\/\/([^\.]+.)?rambler.ru/, 'query'],
      :yandex     => [/^https?:\/\/(www\.)?yandex.ru/, 'text'],      

      # Borrowed from https://github.com/squeejee/search_sniffer
      :msn        => [/^https?:\/\/search\.msn.*/, 'q'],
      :aol        => [/^https?:\/\/(www\.)?\.aol.*/, 'query'],
      :altavista  => [/^https?:\/\/(www\.)?altavista.*/, 'q'],
      :feedster   => [/^https?:\/\/(www\.)?feedster.*/, 'q'],
      :lycos      => [/^https?:\/\/search\.lycos.*/, 'query'],
      :alltheweb  => [/^https?:\/\/(www\.)?alltheweb.*/, 'q'] 
      
      # Want to add support for more? A good place to start would be this list (note that they
      # give example domains, though, not anything we can use to construct a reliable reg exp):
      # http://code.google.com/apis/analytics/docs/tracking/gaTrackingTraffic.html#searchEngine
    }
    
    def initialize(app, opts = {})
      @app = app
      
      @engines   = opts[:engines]
      @engines ||= DEFAULT_ENGINES.merge(opts[:additional_engines] || {})
    end      

    def call(env)
      request = Rack::Request.new(env)
      from = request.env["HTTP_REFERER"]
      
      if from.to_s.length > 0
        if engine = @engines.detect {|name, data| from =~ data[0] }
          env["referring.search_engine"] = engine[0].to_s
          reg, param_name = engine[1]
          
          # Pull out the query string from the referring search engine
          query_string = begin
            URI.split(from)[7]
          rescue URI::InvalidURIError; nil
          end
          
          env["referring.search_phrase"] = query_string && Rack::Utils.parse_query(query_string)[param_name]
        end
      end
      
      @app.call(env)
    end
    
  end
end
