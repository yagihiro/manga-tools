# frozen_string_literal: true

require 'faraday'
require 'uri'
require_relative 'version'

module Manga
  module Tools
    # HTTP client class
    module Http
      # @param url [String] an url string, eg: `https://example.com`
      # @param session_id [String, nil] A Session ID string or nil
      # @return [Faraday::Connection] a connection object
      def self.connection(url, session_id)
        headers = { 'User-Agent' => user_agent }
        headers['X-Session-ID'] = session_id if session_id

        @connection = Faraday.new(url: url, headers: headers) do |f|
          # f.response :logger
        end
      end

      # @param url [String] an url string, eg: `https://example.com/path/to/object`
      # @param session_id [String, nil] A Session ID string or nil
      # @return [Faraday::Response] a response object
      def self.get(url, session_id)
        u = URI.parse(url)
        connection(connection_url(u), session_id).get(u.request_uri)
      end

      # @param url [URI] A URL instance.
      # @return [String] Returns the URL to connect to.
      #
      # If the port is not a standard port (80 or 443), the port number is included.
      def self.connection_url(url)
        if [80, 443].include?(url.port)
          "#{url.scheme}://#{url.host}"
        else
          "#{url.scheme}://#{url.host}:#{url.port}"
        end
      end

      # @return [String] Returns a user agent string
      def self.user_agent
        @user_agent ||= "manga-tools #{Manga::Tools::VERSION}"
      end
    end
  end
end
