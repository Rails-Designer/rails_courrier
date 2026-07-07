require "test_helper"

class Courrier::Email::DeliveryJobTest < Minitest::Test
  include TestEmailHelpers

  def setup
    reset_configuration

    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

  def test_perform_creates_email_and_delivers_now
    mock_provider = create_mock_provider

    Courrier::Email::Provider.stub :new, ->(_) { mock_provider } do
      result = Courrier::Email::DeliveryJob.new.perform(
        "TestEmail",
        from: "devs@railsdesigner.com",
        to: "recipient@railsdesigner.com"
      )

      assert_equal "delivery_result", result
    end
  end

  def test_perform_preserves_context_options_for_template_rendering
    mock_provider = create_mock_provider
    options_captured = nil

    Courrier::Email::Provider.stub :new, ->(options) {
      options_captured = options

      mock_provider
    } do
      Courrier::Email::DeliveryJob.new.perform(
        "TestEmailWithContext",
        from: "devs@railsdesigner.com",
        to: "recipient@railsdesigner.com",
        order_id: "42",
        token: "abc"
      )
    end

    assert_equal "Order 42", options_captured[:options].subject
    assert_equal "Test order 42 with token abc", options_captured[:options].text
  end

  def test_deliver_later_enqueues_job_with_email_class_and_options
    Courrier.configure do |config|
      config.email = {provider: "logger"}
    end

    TestEmail.deliver_later(from: "devs@railsdesigner.com", to: "recipient@railsdesigner.com")

    assert_equal 1, ActiveJob::Base.queue_adapter.enqueued_jobs.size

    job = ActiveJob::Base.queue_adapter.enqueued_jobs.first
    assert_equal "Courrier::Email::DeliveryJob", job[:job].name
    assert_equal "TestEmail", job[:args][0]
    assert_equal "devs@railsdesigner.com", job[:args][1]["from"]
    assert_equal "recipient@railsdesigner.com", job[:args][1]["to"]
  end

  def test_deliver_later_forwards_queue_options
    TestEmail.enqueue(queue: "emails", wait: 300)

    TestEmail.deliver_later(from: "devs@railsdesigner.com", to: "recipient@railsdesigner.com")

    job = ActiveJob::Base.queue_adapter.enqueued_jobs.first
    assert_equal "emails", job[:queue]
  end

  def test_perform_fires_delivery_courrier_notification
    events = []
    subscriber = ActiveSupport::Notifications.subscribe("delivery.courrier") do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    mock_provider = create_mock_provider

    Courrier::Email::Provider.stub :new, ->(_) { mock_provider } do
      Courrier::Email::DeliveryJob.new.perform(
        "TestEmail",
        from: "devs@railsdesigner.com",
        to: "recipient@railsdesigner.com"
      )
    end

    assert_equal 1, events.size
    assert_equal "delivery.courrier", events.first.name
    assert_equal "TestEmail", events.first.payload[:email]
    assert_equal "devs@railsdesigner.com", events.first.payload[:options][:from]
    assert_equal "recipient@railsdesigner.com", events.first.payload[:options][:to]
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  def test_perform_fires_delivery_failed_courrier_notification_on_error
    events = []
    subscriber = ActiveSupport::Notifications.subscribe("delivery_failed.courrier") do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    begin
      Courrier::Email::Provider.stub :new, ->(_) { raise "provider_boom" } do
        Courrier::Email::DeliveryJob.new.perform(
          "TestEmail",
          from: "devs@railsdesigner.com",
          to: "recipient@railsdesigner.com"
        )
      end
    rescue RuntimeError
    end

    assert_equal 1, events.size
    assert_equal "delivery_failed.courrier", events.first.name
    assert_equal "TestEmail", events.first.payload[:email]
    assert_equal "RuntimeError", events.first.payload[:exception][0]
    assert_equal "provider_boom", events.first.payload[:exception][1]
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  def test_perform_still_raises_on_error
    Courrier::Email::Provider.stub :new, ->(_) { raise "provider_boom" } do
      assert_raises(RuntimeError, "provider_boom") do
        Courrier::Email::DeliveryJob.new.perform(
          "TestEmail",
          from: "devs@railsdesigner.com",
          to: "recipient@railsdesigner.com"
        )
      end
    end
  end
end
