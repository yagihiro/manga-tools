# frozen_string_literal: true

require 'cgi'
require 'json'
require_relative 'http'
require_relative 'session'

module Manga
  module Tools
    # Client Application class
    class Client
      # @return [Manga::Tools::Session] a session instance
      attr :session

      def initialize
        @session = Manga::Tools::Session.new
      end

      # Search `word` with options.
      # @param word [String] search string
      # @param options [Hash] command options from Thor
      def search(word, options)
        session.options = adapt_to_dev_env(options)
        session.get("/publications?keyword=#{CGI.escape(word)}")
      end

      def follow(key, options)
        params = { key: key }
        session.options = adapt_to_dev_env(options)
        session.post('/follows', params)
      end

      private

      def adapt_to_dev_env(options)
        opts = options.dup

        if opts[:host]
          # If the `host` option is specified, it is assumed to be the development environment
          opts[:session_file_name] = 'session-development.txt'
        end

        opts
      end
    end
  end
end
