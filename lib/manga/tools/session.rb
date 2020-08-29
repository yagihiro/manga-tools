# frozen_string_literal: true

require 'fileutils'
require 'json'
require_relative 'http'

module Manga
  module Tools
    # Network Session class (Session ID handling + HTTP CRUD handling)
    class Session
      DEFAULT_HOST = 'https://manga-tools-server.herokuapp.com'

      # @return [Hash] options hash instance
      attr :options

      def initialize
        create_session_dir_if_necessary
        @options = {}
      end

      def options=(new_options)
        @base_url = nil
        @options = new_options
      end

      def get(path)
        response = with_session { |session_id| Manga::Tools::Http.get(build_full_url(path), session_id) }
        JSON.parse(response.body)
      end

      def post(path, params)
        response = with_session { |session_id| Manga::Tools::Http.post(build_full_url(path), session_id, params) }
        JSON.parse(response.body)
      end

      private

      def with_session
        session_id = load
        results = yield session_id
        store(results)
        results
      end

      def base_url
        @base_url ||= options[:host] ? "http://#{options[:host]}" : DEFAULT_HOST
      end

      def build_full_url(path)
        "#{base_url}#{path}"
      end

      # Store a session.
      # @param response [Faraday::Response] a response from server as Faraday::Response
      def store(response)
        session_id = response.headers['X-Session-ID']
        _store(session_id) if session_id
      end

      # @return [String, nil] Returns the session ID if the session is stored, otherwise it returns nil
      def load
        return nil unless File.exist?(session_file_path)

        File.read(session_file_path)
      end

      # @return [String] the root directory
      def root_dir
        @root_dir ||= "#{Dir.home}/.manga-tools"
      end

      # @return [String] the session directory
      def session_dir
        @session_dir ||= "#{root_dir}/session"
      end

      def session_file_name
        @session_file_name ||= options[:session_file_name] || 'session.txt'
      end

      # @return [String] the session file path
      def session_file_path
        @session_file_path ||= "#{session_dir}/#{session_file_name}"
      end

      def _store(session_id)
        return if File.exist?(session_file_path)

        File.open(session_file_path, 'w') do |f|
          f.write(session_id)
        end
      end

      def create_session_dir_if_necessary
        FileUtils.mkdir_p(session_dir)
      end
    end
  end
end
