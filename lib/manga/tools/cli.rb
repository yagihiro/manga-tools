# frozen_string_literal: true

require 'json'
require 'nokogiri'
require 'stringio'
require 'thor'

module Manga
  module Tools
    class CLI < Thor
      def self.exit_on_failure?
        true
      end

      # desc "pub {name}", "publication date of {name}"
      # def pub(name)
      #   doc = Nokogiri::HTML(
      #     URI.open('https://tsutaya.tsite.jp/feature/book/release/comic/index', 'User-Agent' => UserAgent)
      #   )
      #
      #   File.open('.index.txt', 'w') {|f| f.write doc }
      #
      #   results = {}
      #
      #   current_date = ''
      #   state = :title
      #   current_data = {}
      #   doc.css('h3, div.comic_list div.c_cols-1of3 span').each do |element|
      #     case element.name
      #     when 'h3'
      #       results[element.content] = []
      #       current_date = element.content
      #     when 'span'
      #       current_data[state] = element.content
      #       case state
      #       when :title
      #         state = :author
      #       when :author
      #         state = :label
      #       when :label
      #         state = :title
      #         results[current_date] << current_data
      #         current_data = {}
      #       end
      #     end
      #   end
      #
      #   puts JSON.pretty_generate(results)
      # end

      desc "pub", "publication date"
      def pub
        Manga::Tools::Cache.init

        t = Time.now
        url = "https://calendar.gameiroiro.com/manga.php?year=#{t.year}&month=#{t.month}"
        data = Manga::Tools::Cache.fetch(key: url) do |cache|
          res = Manga::Tools::Http.get(url)
          cache.expires_in = Manga::Tools::Http.seconds_to_cache(res)
          results = pub_internal(res.body)
          results.to_json
        end

        puts JSON.parse(data)
      end

      private

      def pub_internal(data)
        doc = Nokogiri::HTML(StringIO.open(data))

        results = {}
        current_date = nil
        state = :genre
        data = {}
        doc.css('td.day-td, div.product-description-right p.p-genre, div.product-description-right a, div.product-description-right p.p-company').each do |element|
          begin
            value = element.content.strip
            case element.name
            when 'td'
              results[value] = []
              current_date = value
            when 'p', 'a'
              case state
              when :genre
                raise 'invalid state' unless element.name == 'p' && element['class'] == 'p-genre'
                data[state] = value
                state = :title
              when :title
                raise 'invalid state' unless element.name == 'a'
                data[state] = value
                data[:link] = element['href']
                state = :company
              when :company
                raise 'invalid state' unless element.name == 'p' && element['class'] == 'p-company'
                data[state] = value
                state = :authors
              when :authors
                raise 'invalid state' unless element.name == 'p' && element['class'] == 'p-company'
                data[state] = value
                state = :genre
                results[current_date] << data
                data = {}
              end
            end
          rescue
            # authors のときに authors が無い場合がある
            if state == :authors
              data[state] = ''
              state = :genre
              results[current_date] << data
              data = {}
            end
            retry
          end
        end

        results
      end
    end
  end
end
