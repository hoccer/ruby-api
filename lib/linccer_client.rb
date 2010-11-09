require 'uuid'
require 'json'
require 'net/http'

module Hoccer
  class LinccerClient

    attr_accessor :uuid

    def self.create
      client = self.new
      client
    end

    def initialize options = {}
      @uuid = UUID.generate
      @host = options[:host] || "linker.beta.hoccer.com"
      @port = options[:port] || 80
    end

    def client_path
      "/clients/#{@uuid}"
    end

    def environment_path
      "/clients/#{@uuid}/environment"
    end

    def action_path mode
      "/clients/#{@uuid}/action/#{mode}"
    end

    def update_environment data
      handle_response put(environment_path, data.to_json)
    end

    def share mode, data
      handle_response put(action_path(mode), data.to_json)
    end

    def receive mode, options = {}
      handle_response get(action_path(mode))
    end

    def handle_response response = nil
      if response.nil?
        raise Hoccer::NoServerResponse
      end

      case response.header.code

      when "200"
        return parse_json( response.body )
      when "201"
        return true
      when "204"
        return nil
      when "412"
        raise Hoccer::InvalidEnvironment
      else
        raise(
          Hoccer::InvalidServerResponse,
          "#{response.header.code} + #{response.header.message}"
        )
      end
    end

    def parse_json response_body
      begin
        payload = JSON.parse( response_body )
      rescue JSON::ParserError => e
        raise Hoccer::InvalidJsonResponse, "Could not parse JSON"
      end
    end

    def follow_redirect
      if @redirect_location
        url = URI.parse @redirect_location
        Net::HTTP.start(url.host, url.port) do |http|
          http.get( url.path )
        end
      end
    end

    def follow_redirect_threaded
      t = Thread.new do
        follow_redirect
      end
      t.value
    end

    def delete_environment
      req = Net::HTTP::Delete.new(environment_path)
      Net::HTTP.start(@host, @port) do |http|
        response = http.request(req)
      end
    end

    def request method, path, data = nil
      Net::HTTP.start(@host, @port) do |http|
        http.send( "request_#{method}".to_sym, path, data )
      end
    end

    def method_missing name, *args
      if %w(get post put delete).include? name.to_s
        request name, *args
      else
        super
      end
    end

  end

  class NoServerResponse      < ArgumentError; end
  class InvalidServerResponse < ArgumentError; end
  class InvalidJsonResponse   < ArgumentError; end
  class InvalidEnvironment    < ArgumentError; end

end
