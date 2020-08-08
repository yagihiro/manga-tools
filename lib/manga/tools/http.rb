# frozen_string_literal: true

require 'faraday'
require 'uri'

module Manga::Tools
  module Http
    UserAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'

    # @param url [String] an url string, eg: `https://example.com`
    # @return [Faraday::Connection] a connection object
    def self.connection(url)
      @connection ||= Faraday.new(
        url: url,
        headers: { 'User-Agent' => UserAgent }
      ) do |f|
        f.response :logger
      end
    end

    # @param url [String] an url string, eg: `https://example.com/path/to/object`
    # @return [Faraday::Response] a response object
    def self.get(url)
      u = URI.parse(url)
      res = connection("#{u.scheme}://#{u.host}").get(u.request_uri)
      res
    end

    # @param response [Faraday::Response] a response object
    # @return [nil|Integer] number of second to cache
    #
    # supported http header
    # - cache-control: max-age=[sec]
    def self.seconds_to_cache(response)
      result = response['cache-control']&.split(/,/)&.map(&:strip)&.find {|item| item =~ /max-age=(.+)/}
      return nil unless result
      $1.to_i
    end
  end
end
