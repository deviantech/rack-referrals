require "rack-referrals/version"

module Rack
  class Referrals
    
    DEFAULT_ENGINES = {
      :google     => [/^http:\/\/(www\.)?google.*/, 'q'],
      :yahoo      => [/^http:\/\/search\.yahoo.*/, 'p'],
      :msn        => [/^http:\/\/search\.msn.*/, 'q'],
      :aol        => [/^http:\/\/search\.aol.*/, 'userQuery'],
      :altavista  => [/^http:\/\/(www\.)?altavista.*/, 'q'],
      :feedster   => [/^http:\/\/(www\.)?feedster.*/, 'q'],
      :lycos      => [/^http:\/\/search\.lycos.*/, 'query'],
      :alltheweb  => [/^http:\/\/(www\.)?alltheweb.*/, 'q'] 
    }
    
    def initialize(app, opts = {})
      @app = app
      
      # require 'ruby-debug'
      # debugger
      
      @engines = opts[:engines] ? opts[:engines] : DEFAULT_ENGINES.merge(opts[:additional_engines] || {})
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
