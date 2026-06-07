# frozen_string_literal: true

module Courrier
  class Configuration
    class Inbox
      attr_accessor :destination, :auto_open, :template_path

      def initialize
        @destination = default_destination
        @auto_open = false
        @template_path = File.expand_path("../../email/providers/inbox/default.html.erb", __dir__)
      end

      private

      def default_destination
        Rails.root.join("tmp", "courrier", "emails").to_s
      end
    end
  end
end
