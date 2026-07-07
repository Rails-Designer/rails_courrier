module Courrier
  class InstallGenerator < Rails::Generators::Base
    desc "Creates the initializer for Courrier"

    source_root File.expand_path("templates", __dir__)

    class_option :events, type: :boolean, default: false, desc: "Generate the courrier_events migration"

    def copy_initializer_file
      template "initializer.rb", "config/initializers/courrier.rb"
    end

    def generate_events
      generate "courrier:events" if options[:events]
    end
  end
end
