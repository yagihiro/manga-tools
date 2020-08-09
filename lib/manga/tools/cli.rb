# frozen_string_literal: true

require 'json'
require 'nokogiri'
require 'stringio'
require 'thor'

module Manga::Tools
  # CLI class
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

    desc 'search WORD', 'Search for a given WORD'
    def search(word)
      Manga::Tools::Cache.init

      t = Time.now
      url = "https://calendar.gameiroiro.com/manga.php?year=#{t.year}&month=#{t.month}"
      data = Manga::Tools::Cache.fetch(key: url) do |cache|
        res = Manga::Tools::Http.get(url)
        cache.expires_in = Manga::Tools::Http.seconds_to_cache(res)
        results = generate_internal_data(t, res.body)
        results.to_json
      end

      hash = JSON.parse(data)

      puts "Searching '#{word}' ..."
      hash.each do |date, items|
        next if items.empty?

        items.each do |item|
          puts "Found: #{date}, #{item['title']}" if item['title'].index(word)
        end
      end
      puts 'Finished.'
    end

    private

    # @param time [Time] a target time
    # @param data [String] a string of HTTP response body.
    def generate_internal_data(time, data)
      doc = Nokogiri::HTML(StringIO.open(data))

      results = {}
      current_date = nil
      state = :genre
      data = {}
      doc.css(targets.join(', ')).each do |element|
        value = rm_spaces(element.content)
        case element.name
        when 'td'
          current_date = format('%<ym>s/%<day>02d', ym: time.strftime('%Y/%m'), day: value.to_i)
          results[current_date] = []
        when 'p', 'a'
          case state
          when :genre
            guard_genre(element)
            data[state] = value
            state = :title
          when :title
            guard_title(element)
            data[state] = value
            data[:link] = element['href']
            state = :company
          when :company
            guard_company(element)
            data[state] = value
            state = :authors
          when :authors
            guard_authors(element)
            data[state] = value
            state = :genre
            results[current_date] << data
            data = {}
          end
        end
      rescue StandardError
        # when authors, authors may not be present.
        if state == :authors
          data[state] = ''
          state = :genre
          results[current_date] << data
          data = {}
        end
        retry
      end

      results
    end

    def targets
      @targets ||= [
        'td.day-td',
        'div.product-description-right p.p-genre',
        'div.product-description-right a',
        'div.product-description-right p.p-company'
      ]
    end

    # Remove HTML spaces (&nbsp;) and white spaces.
    # @param str [String] a string
    def rm_spaces(str)
      str.gsub("\u00A0", '').strip
    end

    def guard_genre(element)
      raise 'invalid state' unless element.name == 'p' && element['class'] == 'p-genre'
    end

    def guard_title(element)
      raise 'invalid state' unless element.name == 'a'
    end

    def guard_company(element)
      raise 'invalid state' unless element.name == 'p' && element['class'] == 'p-company'
    end

    alias guard_authors guard_company
  end
end
