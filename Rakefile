# frozen_string_literal: true

# Update schema

dump_schema = lambda do
  # https://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/SchemaDumper.html#method-i-dump_schema_migration
  # schema = DB.dump_schema_migration(same_db: true) # bad result
  schema = `sequel -D #{DB.opts[:uri]}` # great!
  body = "# Version: #{Time.now.strftime("%Y%m%d%H%M%S\n")}#{schema}"
  File.open('db/schema.rb', 'w') { |f| f.write(body) }
end

# Migrate

migrate = lambda do |env, version|
  ENV['RACK_ENV'] = env
  begin
    require_relative '.env'
  rescue LoadError
    # do nothing
  end
  require 'config'
  require_relative 'config/initializers/config'
  require_relative 'config/initializers/db'
  Sequel.extension :migration
  DB.loggers << Ougai::Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'db/migrations', version)
end

desc 'Migrate test database to latest version'
task :test_up do
  migrate.call('test', nil)
  dump_schema.call
end

desc 'Migrate test database all the way down'
task :test_down do
  migrate.call('test', 0)
  dump_schema.call
end

desc 'Migrate test database all the way down and then back up'
task :test_bounce do
  migrate.call('test', 0)
  Sequel::Migrator.apply(DB, 'db/migrations')
  dump_schema.call
end

desc 'Migrate development database to latest version'
task :dev_up do
  migrate.call('development', nil)
  dump_schema.call
end

desc 'Migrate development database to all the way down'
task :dev_down do
  migrate.call('development', 0)
  dump_schema.call
end

desc 'Migrate development database all the way down and then back up'
task :dev_bounce do
  migrate.call('development', 0)
  Sequel::Migrator.apply(DB, 'db/migrations')
  dump_schema.call
end

desc 'Migrate production database to latest version'
task :prod_up do
  migrate.call('production', nil)
end

desc 'Migrate production database to all the way down'
task :prod_down do
  migrate.call('production', 0)
  dump_schema.call
end

# Seed

seeds = lambda do |env|
  ENV['RACK_ENV'] = env
  begin
    require_relative '.env'
  rescue LoadError
    # do nothing
  end
  require 'i18n'
  require 'config'
  require_relative 'config/initializers/config'
  require_relative 'config/initializers/db'
  require_relative 'config/initializers/models'
  require_relative 'config/application_loader'
  require_relative 'config/initializers/i18n'
  require_relative 'db/seeds'
  require 'ougai'
  DB.loggers << Ougai::Logger.new($stdout) if DB.loggers.empty?
end

desc 'Seed test database'
task :test_seed do
  seeds.call('test')
end

desc 'Seed development database'
task :dev_seed do
  seeds.call('development')
end

desc 'Seed production database'
task :prod_seed do
  seeds.call('production')
end

Rake.add_rakelib('rakelib/**')
