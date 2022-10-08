# frozen_string_literal: true

# CODE EXECUTION ORDER IS IMPORTANT DURING SEQUEL INITIALIZATION PROCESS.
# See http://sequel.jeremyevans.net/rdoc/files/doc/code_order_rdoc.html

require 'sequel/core'

# Delete ADS_MICROSERVICE_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  ADS_MICROSERVICE_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('ADS_MICROSERVICE_DATABASE_URL'), Settings.db&.to_hash&.compact! || {})

# Load Sequel Database/Global extensions here
DB.extension :pagination

# https://github.com/jeremyevans/sequel/blob/master/lib/sequel/extensions/schema_dumper.rb
DB.extension :schema_dumper

# https://github.com/jeremyevans/sequel/blob/7a70ac6d719c21bcb404adf6159cbd2769d9246f/lib/sequel/extensions/pg_timestamptz.rb
DB.extension :pg_timestamptz

Sequel.default_timezone = :utc
