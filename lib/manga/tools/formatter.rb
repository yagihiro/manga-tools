# frozen_string_literal: true

module Manga
  module Tools
    # Formatter class
    class Formatter
      class << self
        def display(command, *results)
          case command
          when :search
            display_search(results)
          when :follow
            display_follow(results)
          when :follow_list
            display_follow_list(results)
          end
        end

        private

        def display_search(results)
          puts "Searching '#{results[0]}' ..."
          results[1].each do |item|
            puts "#{item['published_at']} [#{item['follow_key']}]: #{item['title']}"
          end
          puts 'Finished.'
        end

        def display_follow(results)
          puts "Followed '#{results[1]['title']}'."
          puts 'Finished.'
        end

        def display_follow_list(results)
          puts 'Listing follow list...'
          results[0].each do |item|
            puts (item['title']).to_s
          end
          puts 'Finished.'
        end
      end
    end
  end
end
