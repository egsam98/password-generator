require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/password_generator'
require_relative '../apps/api/application'

Hanami.configure do
  mount Api::Application, at: '/api/v1'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/password_generator_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/password_generator_development'
    #    adapter :sql, 'mysql://localhost/password_generator_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []
  end
end
