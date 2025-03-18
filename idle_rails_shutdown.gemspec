# frozen_string_literal: true

require_relative "lib/idle_rails_shutdown/version"

Gem::Specification.new do |spec|
  spec.name = "idle_rails_shutdown"
  spec.version = IdleRailsShutdown::VERSION
  spec.authors = [ "Erwin Kroon"]
  spec.email = [ "email@hidden" ]

  spec.summary = "Health check mechanism for Rails applications on Fly.io"
  spec.description = "Monitors application health by tracking event frequency and shutting down when events stop, replacing ShutdownJob functionality with an ActiveSupport::Subscriber"
  spec.homepage = "https://github.com/ekroon/idle_rails_shutdown"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "rails", ">= 7.0"
end
