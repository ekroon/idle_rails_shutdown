# frozen_string_literal: true

module IdleRailsShutdown
  class Railtie < Rails::Railtie
    config.idle_rails_shutdown = ActiveSupport::OrderedOptions.new
    config.idle_rails_shutdown.enabled = false
    config.idle_rails_shutdown.check_interval = 1.minute
    config.idle_rails_shutdown.shutdown_threshold = 1.minute

    initializer "idle_rails_shutdown.configure" do |app|
      Rails.application.config.after_initialize do
        if app.config.idle_rails_shutdown.enabled
          IdleRailsShutdown.configure do |config|
            config.check_interval = app.config.idle_rails_shutdown.check_interval
            config.shutdown_threshold = app.config.idle_rails_shutdown.shutdown_threshold
          end
          IdleRailsShutdown.setup
        end
      end
    end
  end
end
