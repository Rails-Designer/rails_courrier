# frozen_string_literal: true

module Courrier
  class Email
    module Translation
      def t(key, **options)
        key = "#{i18n_scope}#{key}" if key.start_with?(".")

        I18n.t(key, **options)
      end

      private

      def i18n_scope
        "courrier.email.#{self.class.name.underscore.tr("/", ".")}"
      end
    end
  end
end
