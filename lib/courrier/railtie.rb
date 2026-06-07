module Courrier
  class Railtie < Rails::Railtie
    config.after_initialize do
      Courrier::Email.default_url_options = Courrier.configuration.default_url_options

      if Courrier.configuration.email_path == File.join("courrier", "emails")
        Courrier.configuration.email_path = Rails.root.join("app", "emails").to_s
      end
    end

    ActiveSupport.on_load(:action_view) do
      include Courrier::Email::Address
    end

    ActiveSupport.on_load(:action_controller) do
      include Courrier::Email::Address
    end

    ActiveSupport.on_load(:active_job) do
      include Courrier::Email::Address
    end

    rake_tasks do
      load File.expand_path("../tasks/courrier.rake", __dir__)
    end

    module ClassMethods
      def deliver_later(**options)
        job = Courrier::Email::DeliveryJob
        job = job.set(**queue_options) if queue_options.any?

        job.perform_later(name, **options)
      end
    end

    module InheritedHook
      def inherited(subclass)
        super

        if Rails.respond_to?(:application) && Rails.application
          subclass.include Rails.application.routes.url_helpers
        end
      end
    end

    Courrier::Email.extend ClassMethods
    Courrier::Email.singleton_class.prepend InheritedHook
  end
end
