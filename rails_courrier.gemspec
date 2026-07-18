# frozen_string_literal: true

require_relative "lib/rails_courrier/version"

Gem::Specification.new do |spec|
  spec.name = "rails_courrier"
  spec.version = RailsCourrier::VERSION
  spec.authors = ["Rails Designer"]
  spec.email = ["devs@railsdesigner.com"]

  spec.summary = "Rails integration for Courrier email delivery"
  spec.description = "Rails engine, generators, ActiveJob support, inbox previews and rake tasks for Courrier."
  spec.homepage = "https://railsdesigner.com/open-source/rails_courrier/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/rails_courrier/"

  spec.files = Dir["{bin,app,config,lib}/**/*", "Rakefile", "README.md", "rails_courrier.gemspec", "Gemfile", "Gemfile.lock"]

  spec.required_ruby_version = ">= 3.4.0"

  spec.add_dependency "courrier", "~> 0.11.0"
  spec.add_dependency "launchy", ">= 3.1", "< 4"
  spec.add_dependency "railties", ">= 7.0"
  spec.add_dependency "actionpack", ">= 7.0"
  spec.add_dependency "activejob", ">= 7.0"
  spec.add_dependency "actionview", ">= 7.0"
end
