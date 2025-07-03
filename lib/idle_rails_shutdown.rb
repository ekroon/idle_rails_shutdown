# frozen_string_literal: true

require_relative "idle_rails_shutdown/version"
require_relative "idle_rails_shutdown/shutdown_subscriber"
require_relative "idle_rails_shutdown/railtie" if defined?(Rails)
require 'active_support/inflector'

module IdleRailsShutdown
  class Error < StandardError; end

  # Configuration options
  class << self
    attr_accessor :check_interval, :shutdown_threshold, :ignore_controllers
    attr_reader :shutdown_callable

    def shutdown_callable=(callable)
      @shutdown_callable = if callable.is_a?(String)
        if callable =~ /\A([A-Za-z0-9_:]+)\.(\w+)\z/
          Regexp.last_match(1).constantize.method(Regexp.last_match(2))
        else
          raise ArgumentError, "Invalid shutdown_callable format"
        end
      else
        callable
      end
    end

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
      @shutdown_callable ||= nil

      # Initialize and subscribe the shutdown subscriber
      ShutdownSubscriber.instance.start_monitoring_thread
    end
  end
end
