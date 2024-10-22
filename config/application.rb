require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ActivityTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.middleware.delete ActionDispatch::Cookies
    config.middleware.delete ActionDispatch::Session::CookieStore

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource( '*',
          headers: :any,
          expose: ["Authorization"],
          methods: [:get, :patch, :put, :delete, :post, :options, :show]
        )
      end
   end

   config.active_job.queue_adapter = :sidekiq
   config.active_storage.queues.purge = :active_storage
   config.active_storage.queues.analysis = :active_storage

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
