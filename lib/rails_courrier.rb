# frozen_string_literal: true

require "active_support"
require "active_job"
require "action_view"
require "action_pack"
require "action_dispatch"
require "rails/railtie"
require "rails/engine"

require "launchy"

require "courrier"
require "courrier/engine"
require "courrier/configuration/inbox"
require "courrier/railtie"
require "courrier/email/delivery_job"
require "courrier/email/providers/inbox"

Courrier::Email::Provider::PROVIDERS[:inbox] = Courrier::Email::Providers::Inbox

module RailsCourrier
end
