# frozen_string_literal: true

require 'faraday'
require 'uri'
require_relative 'version'

module Manga
  module Tools
    # HTTP client class
    module Http
      # @param url [String] an url string, eg: `https://example.com`
      # @return [Faraday::Connection] a connection object
      def self.connection(url)
        @connection ||= Faraday.new(
          url: url,
          headers: { 'User-Agent' => user_agent }
        ) do |f|
          # f.response :logger
        end
      end

      # @param url [String] an url string, eg: `https://example.com/path/to/object`
      # @return [Faraday::Response] a response object
      def self.get(url)
        u = URI.parse(url)
        connection(connection_url(u)).get(u.request_uri)
      end

      def self.connection_url(url)
        if [80, 443].include?(url.port)
          "#{url.scheme}://#{url.host}"
        else
          "#{url.scheme}://#{url.host}:#{url.port}"
        end
      end

      # @param response [Faraday::Response] a response object
      # @return [nil|Integer] number of second to cache
      #
      # supported http header
      # - cache-control: max-age=[sec]
      def self.seconds_to_cache(response)
        result = response['cache-control']&.split(/,/)&.map(&:strip)&.find { |item| item =~ /max-age=(.+)/ }
        return nil unless result

        Regexp.last_match(1).to_i
      end

      def self.user_agent
        @user_agent ||= "manga-tools #{Manga::Tools::VERSION}"
      end
    end
  end
end
