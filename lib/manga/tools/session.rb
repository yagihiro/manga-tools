# frozen_string_literal: true

require 'json'
require_relative 'http'
require_relative 'session_store'

module Manga
  module Tools
    # Network Session class (Session ID handling + HTTP CRUD handling)
    class Session
      DEFAULT_HOST = 'https://manga-tools-server.herokuapp.com'

      # @return [Hash] options hash instance
      attr :options

      # @return [SessionStore] the session store instance
      attr :store

      def initialize
        @store = Manga::Tools::SessionStore.new
        @options = {}
      end

      def options=(new_options)
        @base_url = nil
        @options = new_options
        store.session_file_name = @options[:session_file_name] if @options[:session_file_name]
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
        session_id = store.load
        res = yield session_id
        session_id = res.headers['X-Session-ID']
        store.store(session_id) if session_id
        res
      end

      def base_url
        @base_url ||= options[:host] ? "http://#{options[:host]}" : DEFAULT_HOST
      end

      def build_full_url(path)
        "#{base_url}#{path}"
      end
    end
  end
end
