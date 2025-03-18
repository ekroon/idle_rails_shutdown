# frozen_string_literal: true

require "active_support/subscriber"
require "active_support/notifications"
require "singleton"

module IdleRailsShutdown
  class ShutdownSubscriber < ActiveSupport::Subscriber
    include Singleton

    attr_reader :last_event_time

    attach_to :action_controller, subscriber = instance

    def process_action(event)
      @last_event_time = Time.now
      Rails.logger.debug "IdleRailsShutdown: Event received, updated last_event_time"
    end

    def start_monitoring_thread
      Thread.new do
        @last_event_time ||= Time.now
        sleep 1.second
        loop do
          sleep IdleRailsShutdown.check_interval
          check_idle_time
        end
      end
    end

    private

    def check_idle_time
      elapsed_time = Time.now - @last_event_time
      Rails.logger.info "IdleRailsShutdown: Time since last event: #{elapsed_time.round(2)}s"

      if elapsed_time >= IdleRailsShutdown.shutdown_threshold
        Rails.logger.warn "IdleRailsShutdown: No events received for #{elapsed_time.round(2)}s, sending SIGINT"
        send_sigint_to_pid(0)
      end
    end

    def send_sigint_to_pid(pid)
      begin
        Process.kill("INT", pid)
        Rails.logger.warn "IdleRailsShutdown: SIGINT signal sent to PID #{pid}"
      rescue Errno::ESRCH
        Rails.logger.error "IdleRailsShutdown: Process #{pid} does not exist"
      rescue Errno::EPERM
        Rails.logger.error "IdleRailsShutdown: Permission denied to send SIGINT to PID #{pid}"
      end
    end
  end
end
