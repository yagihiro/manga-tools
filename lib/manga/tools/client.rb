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
        session.options = options
        session.get("/publications?keyword=#{CGI.escape(word)}")
      end
    end
  end
end
