require 'uuid'
require 'json'
require 'net/http'

class TestClient

  attr_accessor :uuid

  def self.create
    client = self.new
    client
  end

  def initialize options = {}
    @uuid = UUID.generate
    @host = options[:host] || "127.0.0.1"
    @port = options[:port] || 9292
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
    put(environment_path, data.to_json)
  end

  def share mode, data
    put(action_path(mode), data.to_json)
  end

  def share mode, data
    put(action_path(mode), data.to_json)
  end

  def share_threaded mode, data
    t = Thread.new do
      share mode, data
    end
  end

  def receive_threaded mode
    t = Thread.new do
      receive mode
    end
    t.value
  end

  def receive mode
    Net::HTTP.start(@host, @port) do |http|
      http.get( action_path(mode) )
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

  def request method, path, data = ""
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
