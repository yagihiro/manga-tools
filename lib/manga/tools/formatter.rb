# frozen_string_literal: true

module Manga
  module Tools
    # Formatter class
    class Formatter
      class << self
        def display(command, *results)
          case command
          when :search
            puts "Searching '#{results[0]}' ..."
            results[1].each do |item|
              puts "#{item['published_at']}: #{item['title']}"
            end
            puts 'Finished.'
          end
        end
      end
    end
  end
end
