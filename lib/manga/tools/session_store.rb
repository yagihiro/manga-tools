# frozen_string_literal: true

require 'fileutils'

module Manga
  module Tools
    # A class on session retention.
    class SessionStore
      # @return [String] the session file name string
      attr_writer :session_file_name

      def initialize
        create_session_dir_if_necessary
        @session_file_name = 'session.txt'
      end

      # Store a session.
      def store(session_id)
        return if exists?

        File.open(session_file_path, 'w') do |f|
          f.write(session_id)
        end
      end

      # @return [String, nil] Returns the session ID if the session is stored, otherwise it returns nil
      def load
        return nil unless exists?

        File.read(session_file_path)
      end

      # @return [Boolean] true if the session exists, otherwise returns false.
      def exists?
        File.exist?(session_file_path)
      end

      # @return [String] the session file path
      def session_file_path
        "#{session_dir}/#{@session_file_name}"
      end

      private

      # @return [String] the root directory
      def root_dir
        @root_dir ||= "#{Dir.home}/.manga-tools"
      end

      # @return [String] the session directory
      def session_dir
        @session_dir ||= "#{root_dir}/session"
      end

      def create_session_dir_if_necessary
        FileUtils.mkdir_p(session_dir)
      end
    end
  end
end
