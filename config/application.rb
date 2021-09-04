require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MovieRama
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2


    config.assets.precompile += %w( article_section.css )
    config.assets.precompile += %w( filter_bar.css )
    config.assets.precompile += %w( form.css )
    config.assets.precompile += %w( header.css )
    config.assets.precompile += %w( new_movie_button.css )
  
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
