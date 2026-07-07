# frozen_string_literal: true

module Courrier
  class Event < ActiveRecord::Base
    self.table_name = "courrier_events"

    mattr_accessor :enabled, default: false

    def self.enabled? = enabled

    def self.record(event_type, metadata: {})
      return unless enabled? && connection.table_exists?(table_name)

      create!(event_type: event_type, metadata: metadata)
    end
  end
end
