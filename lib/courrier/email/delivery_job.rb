# frozen_string_literal: true

module Courrier
  class Email
    class DeliveryJob < ActiveJob::Base
      def perform(email_class_name, **options)
        Object.const_get(email_class_name).new(**options).deliver_now
      end
    end
  end
end
