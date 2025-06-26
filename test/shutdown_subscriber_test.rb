require 'test_helper'
require 'securerandom'

class ShutdownSubscriberTest < Minitest::Test
  def setup
    IdleRailsShutdown.configure do |config|
      config.check_interval = 0.1
      config.shutdown_threshold = 0.1
      config.ignore_controllers = []
    end
    @subscriber = IdleRailsShutdown::ShutdownSubscriber.instance
  end

  def build_event(controller)
    now = Time.now
    ActiveSupport::Notifications::Event.new(
      'process_action.action_controller',
      now, now, SecureRandom.hex(6), { controller: controller }
    )
  end

  def test_process_action_updates_last_event_time
    event = build_event('PostsController')
    @subscriber.process_action(event)
    assert_in_delta Time.now, @subscriber.last_event_time, 0.5
  end

  def test_process_action_ignored_controller
    original_time = Time.now - 5
    @subscriber.instance_variable_set(:@last_event_time, original_time)
    IdleRailsShutdown.ignore_controllers = ['AdminController']
    event = build_event('AdminController')
    @subscriber.process_action(event)
    assert_equal original_time, @subscriber.last_event_time
  end

  def test_check_idle_time_triggers_sigint
    @subscriber.instance_variable_set(:@last_event_time, Time.now - 1)
    called = false

    @subscriber.stub(:send_sigint_to_pid, ->(_pid) { called = true }) do
      @subscriber.send(:check_idle_time)
    end

    assert called
  end

  def test_check_idle_time_no_sigint_when_recent
    @subscriber.instance_variable_set(:@last_event_time, Time.now)
    called = false

    @subscriber.stub(:send_sigint_to_pid, ->(_pid) { called = true }) do
      @subscriber.send(:check_idle_time)
    end

    refute called
  end
end
