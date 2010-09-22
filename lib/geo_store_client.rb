require 'net/http'
require 'json'

module Hoccer

  class GeoStoreClient

    def initialize
      @server = "geostore.beta.hoccer.com"
      @port   = 80
    end

    def validate options, key, class_name
      unless options[key] && options[key].is_a?( class_name )
        raise(
          ArgumentError,
          "#{key.capitalize} is missing or not a #{class_name.to_s}"
        )
      end
    end

    def prepare options
      validate options, :longitude, Float
      validate options, :latitude,  Float
      validate options, :params,    Hash

      {
        :environment => {
          :gps => {
            :longitude  => options[:longitude],
            :latitude   => options[:latitude],
            :accuracy   => options[:accuracy] || 5
          }
        },
        :params   => options[:params],
        :lifetime => options[:liftime]
      }
    end

    def store options
      data = prepare( options )
      post "/store", data
    end

    def remove uuid
      delete "/store/#{uuid}"
    end

    def search_within_radius options
      validate options, :longitude, Float
      validate options, :latitude,  Float
      validate options, :radius,    Float

      options[:accuracy] = options.delete(:radius)

      post "/query", { :gps => options }
    end

    def search_within_region options
      validate options, :region,    Array

      unless options[:region].all? {|x| x.is_a? Array}
        raise ArgumentError, "Region must be of format [[lon1,lat1], [lon2,lat2]]"
      end

      post "/query", { :box => options[:region] }
    end

    def request method, path, data = {}
      if method == :delete
        Net::HTTP.start(@server, @port) do |http|
          req = Net::HTTP::Delete.new(path)
          response = http.request(req)
        end
      else
        Net::HTTP.start(@server, @port) do |http|
          http.send( "request_#{method}".to_sym, path, data.to_json)
        end
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

end
