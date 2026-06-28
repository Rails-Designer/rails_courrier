# frozen_string_literal: true

module Courrier
  class PreviewsController < ActionController::Base
    def index
      # previews = Courrier::Preview.all

      @emails = previews.map do |class_name, scenarios|
        first_scenario = scenarios.keys.first

        Courrier::Preview::Email.new(
          primary: class_name,
          secondary: nil,
          link: courrier.preview_path(id: class_name, scenario: first_scenario),
          scenarios: scenarios.map { |name, _|
            {name: name, link: courrier.preview_path(id: class_name, scenario: name)}
          }
        )
      end
    end

    def show
      email_class = params[:id]
      scenario = params[:scenario] || previews_for(email_class).keys.first

      @email = Courrier::Preview.render(email_class, scenario)
    rescue NameError, KeyError
      head :not_found
    end

    private

    # TODO: does not properly reload
    def previews
      eager_load_emails
      collect_descendants(Courrier::Email)
        .select { it.previews.any? }
        .to_h { [it.name, it.previews] }
    end

    def eager_load_emails
      if defined?(Rails.autoloaders) && Courrier.configuration.email_path.present?
        path = Courrier.configuration.email_path
        Rails.autoloaders.main.eager_load_dir(path) if File.directory?(path)
      end
    end

    def collect_descendants(klass)
      klass.subclasses.flat_map { |sub| [sub] + collect_descendants(sub) }
    end

    def previews_for(email_class)
      Courrier::Preview.all.fetch(email_class) { raise KeyError }
    end
  end
end
