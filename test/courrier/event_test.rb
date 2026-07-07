require "test_helper"
require "active_record"
$LOAD_PATH.unshift File.expand_path("../../app/models", __dir__)
require "courrier/event"

class Courrier::EventTest < Minitest::Test
  def setup
    Courrier::Event.enabled = true
    establish_database_connection
    create_events_table
  end

  def teardown
    drop_events_table
    Courrier::Event.enabled = false
  end

  def test_record_creates_event_with_event_type
    event = Courrier::Event.record("email.delivered")

    assert_predicate event, :persisted?
    assert_equal "email.delivered", event.event_type
  end

  def test_record_stores_metadata
    event = Courrier::Event.record("email.delivered", metadata: {to: "user@example.com", subject: "Hello"})

    assert_equal "user@example.com", event.metadata["to"]
    assert_equal "Hello", event.metadata["subject"]
  end

  def test_record_defaults_metadata_to_empty_hash
    event = Courrier::Event.record("email.delivered")

    assert_equal ({}), event.metadata
  end

  def test_record_returns_nil_when_table_does_not_exist
    drop_events_table

    result = Courrier::Event.record("email.delivered")

    assert_nil result
  end

  def test_record_returns_nil_when_disabled
    Courrier::Event.enabled = false

    result = Courrier::Event.record("email.delivered")

    assert_nil result
  end

  private

  def establish_database_connection
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
  end

  def create_events_table
    ActiveRecord::Schema.define do
      create_table :courrier_events do |t|
        t.string :event_type, null: false
        t.json :metadata, default: {}

        t.timestamp :created_at
      end
    end
  end

  def drop_events_table
    ActiveRecord::Migration.drop_table(:courrier_events) if Courrier::Event.connection.table_exists?("courrier_events")
  end
end
