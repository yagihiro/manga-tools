# frozen_string_literal: true

require 'json'
require 'thor'
require_relative 'client'
require_relative 'formatter'

module Manga
  module Tools
    # CLI class
    class CLI < Thor
      HOST_OPTION = { aliases: '-h', desc: 'Specifies the host to connect to for development' }.freeze

      def self.exit_on_failure?
        true
      end

      desc 'search WORD', 'Search titles for a given WORD'
      method_option :host, HOST_OPTION
      def search(word)
        client = Manga::Tools::Client.new
        results = client.search(word, options)
        Manga::Tools::Formatter.display(:search, word, results)
      end

      desc 'follow KEY', 'Follow a title for a given follow KEY'
      method_option :host, HOST_OPTION
      def follow(key)
        client = Manga::Tools::Client.new
        results = client.follow(key, options)
        Manga::Tools::Formatter.display(:follow, key, results)
      end

      desc 'follow-list', 'Displays the follow list'
      method_option :host, HOST_OPTION
      def follow_list
        client = Manga::Tools::Client.new
        results = client.follow_list(options)
        Manga::Tools::Formatter.display(:follow_list, results)
      end
    end
  end
end
