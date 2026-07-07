module Courrier
  class EventsGenerator < Rails::Generators::Base
    desc "Copies the courrier_events migration to the host app"

    def create_migrations
      rails_command "railties:install:migrations FROM=courrier", inline: true
    end
  end
end
