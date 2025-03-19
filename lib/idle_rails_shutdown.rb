# frozen_string_literal: true

require_relative "idle_rails_shutdown/version"
require_relative "idle_rails_shutdown/shutdown_subscriber"
require_relative "idle_rails_shutdown/railtie" if defined?(Rails)

module IdleRailsShutdown
  class Error < StandardError; end

  # Configuration options
  class << self
    attr_accessor :check_interval, :shutdown_threshold, :ignore_controllers

    def configure
      yield self if block_given?
      @configured = true
    end

    def configured?
      !!@configured
    end

    def setup
      # Set default configuration
      @check_interval ||= 1.minute
      @shutdown_threshold ||= 1.minute
      @ignore_controllers ||= []

      # Initialize and subscribe the shutdown subscriber
      ShutdownSubscriber.instance.start_monitoring_thread
    end
  end
end
