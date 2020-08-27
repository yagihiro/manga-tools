# frozen_string_literal: true

require 'json'
require 'thor'
require_relative 'client'
require_relative 'formatter'

module Manga
  module Tools
    # CLI class
    class CLI < Thor
      def self.exit_on_failure?
        true
      end

      desc 'search WORD', 'Search titles for a given WORD'
      method_option :host, aliases: '-h', desc: 'Specifies the host to connect to for development'
      def search(word)
        client = Manga::Tools::Client.new
        results = client.search(word, options)
        Manga::Tools::Formatter.display(:search, word, results)
      end
    end
  end
end
