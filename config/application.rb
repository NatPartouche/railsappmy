require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application

	config.middleware.use Rack::Cors do
	      allow do
	        origins '*'
	        resource '*',
	          :headers => :any,
	          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
	          :methods => [:get, :post, :options, :delete, :put]
	      end
	 end
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
