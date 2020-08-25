# frozen_string_literal: true

require 'json'
require 'thor'
require_relative 'http'

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
        host = options[:host] ? "http://#{options[:host]}" : 'https://manga-tools-server.herokuapp.com'
        url = "#{host}/publications?keyword=#{CGI.escape(word)}"
        res = Manga::Tools::Http.get(url)
        results = JSON.parse(res.body)

        puts "Searching '#{word}' ..."
        results.each do |item|
          puts "#{item['published_at']}: #{item['title']}"
        end
        puts 'Finished.'
      end
    end
  end
end
