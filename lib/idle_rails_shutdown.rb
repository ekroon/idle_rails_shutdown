# frozen_string_literal: true

require_relative "idle_rails_shutdown/version"
require_relative "idle_rails_shutdown/shutdown_subscriber"
require_relative "idle_rails_shutdown/railtie" if defined?(Rails)

module IdleRailsShutdown
  class Error < StandardError; end

  # Configuration options
  class << self
    attr_accessor :check_interval, :shutdown_threshold

    def configure
      yield self if block_given?
    end

    def setup
      # Set default configuration
      @check_interval ||= 1.minute
      @shutdown_threshold ||= 1.minute

      # Initialize and subscribe the shutdown subscriber
      ShutdownSubscriber.instance
    end
  end
end
