module Courrier
  class InstallGenerator < Rails::Generators::Base
    desc "Creates the initializer for Courrier"

    source_root File.expand_path("templates", __dir__)

    class_option :provider, type: :string, desc: "Email delivery provider (#{Courrier::Email::Provider::PROVIDERS.keys.join(", ")})"

    def copy_initializer_file
      template "initializer.rb", "config/initializers/courrier.rb"
    end

    private

    def provider_config_options
      provider_class = Courrier::Email::Provider::PROVIDERS[options[:provider]&.to_sym]

      provider_class ? provider_class.config_options : []
    end
  end
end
