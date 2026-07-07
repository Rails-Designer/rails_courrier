# frozen_string_literal: true

module Courrier
  class Email
    class DeliveryJob < ActiveJob::Base
      def perform(email_class_name, **options)
        Object.const_get(email_class_name).new(**options).deliver_now.tap do
          ActiveSupport::Notifications.instrument("delivery.courrier", email: email_class_name, options: options)
        end
      rescue => exception
        ActiveSupport::Notifications.instrument("delivery_failed.courrier", email: email_class_name, options: options, exception: [exception.class.name, exception.message])
        raise
      end
    end
  end
end
