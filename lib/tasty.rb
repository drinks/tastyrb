require 'httparty'
require 'hashie'
require 'json'
require 'uri'

module Tastyrb

  class Client

    module Connection
      include HTTParty
    end

    attr_accessor :api_key, :api_key_param, :jsonp_callback, :word_separator, :limit
    attr_reader :resources, :meta

    def initialize(url=nil, api_key=nil, jsonp_callback=nil)
      @resources = []
      if url
        base_uri = url
      end
      @api_key = api_key
      @api_key_param = 'api_key'
      @jsonp_callback = jsonp_callback
      @word_separator = '_'
    end

    def base_uri=(url)
      @base_uri = url
      redefine_resources!
    end

    def base_uri
      @base_uri
    end

    def base_uri_path
      URI.parse(@base_uri).path
    end

    def get(method, options)
      params = prepare_options options
      if params[:callback]
        Connection.format :plain
      else
        Connection.format :json
      end

      response = Connection.get "#{@base_uri}/#{path_for(method)}", :query => params

      if response.code == 200
        # JSONP
        return response.body if Connection.format == :plain

        # JSON
        result = JSON.parse(response.body)['objects']
        meta = JSON.parse(response.body)['meta']
        @meta = Response.new(meta)

        case result.size
        when 0
          raise ResponseCodeError, "404: No document found"
        when 1
          Response.new(result[0])
        else
          result.map {|object| Response.new(object)}
        end
      else
        raise ResponseCodeError, "#{response.code}: #{response.body}"
      end

    end

    def next
      get_from_meta(meta.next)
    end

    def previous
      get_from_meta(meta.previous)
    end

    private

    def get_from_meta(uri)
      path, params = uri.split('?')
      params = Hash[*params.split(/[&=]/)]
      params.delete('format')
      get method_for(path), params
    end

    def method_for(path)
      path.to_s.sub(base_uri_path, '').gsub('/', '__').gsub(@word_separator, '_')
    end

    def path_for(method)
      method.to_s.gsub('__', '/').gsub('_', @word_separator)
    end

    def prepare_options(options)
      options[:callback] = @jsonp_callback if @jsonp_callback
      options[:limit] = @limit if @limit

      if options[:callback] != nil
        options[:format] = 'jsonp'
      else
        options[:format] = 'json'
      end

      options.merge @api_key_param.to_sym => @api_key
    end

    def redefine_resources!
      # a given base_uri has unique resources associated with it
      # we map them dynamically to methods each time the url changes
      #> c = Tastyrb::Client.new
      #> c.base_uri='http://example.com/api/v1'
      #> c.my__search__method(:keywords=>'foo')
      @resources.each do |resource|
        (class << self; self; end).class_eval do
          remove_method resource
        end
      end

      resource_desc = Connection.get(@base_uri, :query=>{:format=>'json'})
      @resources = resource_desc.parsed_response.map do |resource|
        method_for(resource[0]).to_sym
      end

      @resources.each do |resource|
        (class << self; self; end).class_eval do
          define_method resource do |*args|
            get(resource, args[0]||{})
          end
        end
      end
    end

  end

  class ResponseCodeError < RuntimeError
  end

  class Response < Hashie::Mash
  end

end
