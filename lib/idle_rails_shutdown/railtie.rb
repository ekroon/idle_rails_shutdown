# frozen_string_literal: true

module IdleRailsShutdown
  class Railtie < Rails::Railtie
    config.idle_rails_shutdown = ActiveSupport::OrderedOptions.new
    config.idle_rails_shutdown.enabled = false
    config.idle_rails_shutdown.check_interval = 1.minute
    config.idle_rails_shutdown.shutdown_threshold = 1.minute
    config.idle_rails_shutdown.ignore_controllers = []
    config.idle_rails_shutdown.shutdown_callable = nil

    initializer "idle_rails_shutdown.configure" do |app|
      Rails.application.config.after_initialize do
        IdleRailsShutdown.configure do |config|
          config.check_interval = app.config.idle_rails_shutdown.check_interval
          config.shutdown_threshold = app.config.idle_rails_shutdown.shutdown_threshold
          config.ignore_controllers = app.config.idle_rails_shutdown.ignore_controllers
          config.shutdown_callable = app.config.idle_rails_shutdown.shutdown_callable
        end
        if app.config.idle_rails_shutdown.enabled
          IdleRailsShutdown.setup
        end
      end
    end
  end
end
