# frozen_string_literal: true

require_relative 'tools/cache'
require_relative 'tools/cli'
require_relative 'tools/http'
require_relative 'tools/version'

module Manga
  module Tools
    class Error < StandardError; end
  end
end
