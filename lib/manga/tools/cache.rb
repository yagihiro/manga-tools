# frozen_string_literal: true

require 'digest/md5'
require 'fileutils'

module Manga::Tools
  # Cache class
  class Cache
    class << self
      # Initialize cache
      def init
        FileUtils.mkdir_p(cache_current_year_dir)
      end

      def root_dir
        @root_dir ||= "#{Dir.home}/.manga-tools"
      end

      def cache_root_dir
        @cache_root_dir ||= "#{root_dir}/cache"
      end

      def cache_current_year_dir
        @cache_current_year_dir ||= "#{cache_root_dir}/#{Time.now.year}"
      end

      # @return [Integer] default expires in seconds (1day)
      def default_expires_in
        @default_expires_in ||= 1 * 24 * 60 * 60
      end

      # @param key [String] A key to generate a key for the cache
      # @return [String] string of cached data
      def fetch(key:)
        raise ArgumentError, 'mast pass a block' unless block_given?

        cache = new(key)
        # cache.clear
        return cache.load_data if cache.available?

        result = yield(cache)
        cache.save_meta_data
        cache.save_data(result)
        result
      end
    end

    # @return [Integer|nil] A cache deadline in seconds.
    attr_accessor :expires_in
    # @return [String] A key to generate a key for the cache.
    attr_reader :key
    # @return [String] A key for the cache.
    attr_reader :cache_key
    # @return [String] A path to the cache metadata file.
    attr_reader :meta_file_path
    # @return [String] A path to the cached data file.
    attr_reader :data_file_path

    # @param key [String] A key to generate a key for the cache.
    def initialize(key)
      raise ArgumentError, 'mast pass the key param' unless key

      @expires_in = self.class.default_expires_in
      @key = key
      @cache_key = Digest::MD5.hexdigest(key)
      @meta_file_path = "#{self.class.cache_current_year_dir}/#{@cache_key}"
      @data_file_path = "#{@meta_file_path}.data"
    end

    # @return [Boolean] True if a cache is available, otherwise return false.
    def available?
      t = File.mtime(meta_file_path)
      saved_expires_in = File.read(meta_file_path).strip.to_i

      Time.now <= (t + saved_expires_in)
    rescue StandardError
      false
    end

    # @return [String] Reads and returns the cache data.
    def load_data
      File.read(data_file_path)
    end

    # Save the metadata for the cache.
    def save_meta_data
      @expires_in = self.class.default_expires_in unless expires_in

      File.open(meta_file_path, 'w') do |f|
        f.write(expires_in.to_s)
      end

      self
    end

    # @param str [String] Save the specified cache data
    def save_data(str)
      File.open(data_file_path, 'w') do |f|
        f.write(str.force_encoding('utf-8'))
      end

      self
    end

    # for debug
    def clear
      File.delete(meta_file_path) if File.exist?(meta_file_path)
      File.delete(data_file_path) if File.exist?(data_file_path)
    end
  end
end
