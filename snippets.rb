'STRING'.downcase
File.open('file.log','a+') { |f| f.write "#{var.inspect}\n" }
u = User.first(order:"RANDOM()")
User.find(27).touch # clear IdentityCache
User.first.created_at.in_time_zone(ActiveSupport::TimeZone["America/Los_Angeles"])
ActiveRecord::Base::sanitize
ActionController::Base.helpers.strip_tags
ActiveRecord::Base.logger = Logger.new(STDOUT) # see SQL in console
$redis.keys.select { |k| $redis.del k } # clear redis the poor man's way
before_filter :auth, unless: -> { Rails.env.development? }

rake db:create db:setup db:migrate
rails g migration AddAutoSubscribeToUsers
rake db:migrate:down VERSION=20131121021805
rake db:rollback STEP=3
rake db:schema:dump db:structure:dump
rake assets:precompile
redis-cli FLUSHALL

# Gems
group :development do
  # debug errors on exception
  gem "better_errors"
  gem "binding_of_caller"
end

# get location of method at runtime
u = User.find_by_uid(1005)
u.method(:statements).source_location

# longer POW timeout
# vim ~/.powconfig
export POW_TIMEOUT=3600

# sidekiq inline
# vim config/environments/development.rb
require 'sidekiq/testing/inline'

# cancel specific jobs in sidekiq retry queue
Sidekiq::RetrySet.new.each { |job| job.delete if job.klass == 'AwesomeButFailingJob' }
Sidekiq::ScheduledSet.new.select { |job| job.klass == 'AwesomeButFailingJob' }.count

# clear sidekiq queues
Sidekiq::Queue.all.map(&:clear)
Sidekiq::ScheduledSet.new.clear
Sidekiq::RetrySet.new.clear

# vim ~/.pryrc
# fix for NoMethodError: undefined method `reload!' for main:Object
include Rails::ConsoleMethods if defined? Rails


# continue the program but ignore binding.pry
disable-pry

# for pry-remote it's more complicated
# application.rb:
module AwesomeApp
  class Application < Rails::Application
    REMOTE_PRY_ENABLED = Time.now()
  end
end
# use this in code
binding.remote_pry if Time.now() > AwesomeApp::Application::REMOTE_PRY_ENABLED
# use this in pry-remote session to continue
AwesomeApp::Application::REMOTE_PRY_ENABLED = Time.now()+1.minute
AwesomeApp::Application::REMOTE_PRY_ENABLED = Time.now()+10.seconds


# database.yml
development: &default
  adapter: postgresql
  encoding: unicode
  # database: _development
  # database: _production
  host: localhost
  pool: 5
  username:
  password:

production: &prod
  <<: *default
  # database: _test

staging:
  <<: *prod

test:
  <<: *prod

# kill all connections to database
psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='app_development';"

# raw queries
res = ActiveRecord::Base.connection.execute("SELECT * FROM VOTES WHERE votable_type = 'Post' AND created_at > NOW()-'1 day'::INTERVAL")
res.count
res[1]

# Database truthy and falsy values
ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES
=> #<Set: {true, 1, "1", "t", "T", "true", "TRUE", "on", "ON"}>
ActiveRecord::ConnectionAdapters::Column::FALSE_VALUES
=> #<Set: {false, 0, "0", "f", "F", "false", "FALSE", "off", "OFF"}>


# HTTParty
require 'httparty'

class HTTPartyDebug
  include HTTParty
  debug_output $stdout
  default_timeout 5
  def method_missing(m)
    self.first.send m
  end
end

HTTPartyDebug.post('https://www.googleapis.com/youtube/v3/subscriptions?part=snippet', headers: { 'Content-Type' => 'application/json', 'Authorization' => 'Bearer ya29.1' }, body: {snippet: {resourceId: {channelId: 'UCOxsR_7dUEp6p2inmL1ZHiA'}}}.to_json)


# forward arguments
alias :really_display :display
def display(*args)
  super args.inspect
  super *args
end


# strip unknown characters
body = HTTParty.get("http://gdata.youtube.com/feeds/api/videos/VtI5HM7GVGY")
JSON.parse(body)
(pry) output error: #<Encoding::UndefinedConversionError: "\xC2" from ASCII-8BIT to UTF-8>
body = body.force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: '')
JSON.parse(body)


# status codes
100 = :continue
101 = :switching_protocols
102 = :processing
200 = :ok
201 = :created
202 = :accepted
203 = :non_authoritative_information
204 = :no_content
205 = :reset_content
206 = :partial_content
207 = :multi_status
226 = :im_used
300 = :multiple_choices
301 = :moved_permanently
302 = :found
303 = :see_other
304 = :not_modified
305 = :use_proxy
307 = :temporary_redirect
400 = :bad_request
401 = :unauthorized
402 = :payment_required
403 = :forbidden
404 = :not_found
405 = :method_not_allowed
406 = :not_acceptable
407 = :proxy_authentication_required
408 = :request_timeout
409 = :conflict
410 = :gone
411 = :length_required
412 = :precondition_failed
413 = :request_entity_too_large
414 = :request_uri_too_long
415 = :unsupported_media_type
416 = :requested_range_not_satisfiable
417 = :expectation_failed
422 = :unprocessable_entity
423 = :locked
424 = :failed_dependency
426 = :upgrade_required
500 = :internal_server_error
501 = :not_implemented
502 = :bad_gateway
503 = :service_unavailable
504 = :gateway_timeout
505 = :http_version_not_supported
507 = :insufficient_storage
510 = :not_extended


# cleanup
vacuumdb -a -f -F
rm ~/Library/Application\ Support/Postgres93/var/pg_log/*

# stop postgres to clean the pg_xlog directory
pg_resetxlog ~/Library/Application\ Support/Postgres93/var/
rm ~/Library/Logs/Pow/access.log

sudo vim /usr/local/etc/mongod.conf
smallfiles=true

launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
rm /usr/local/var/mongodb/journal/*
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist


# build gem
git clone https://github.com/jugyo/tunnels
cd tunnels
gem build tunnels.gemspec
gem install tunnels-1.2.0.gem

openssl req -nodes -new -x509 -keyout server.key -out server.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=*.dev"
sudo tunnels

# Mac OS X instructions
# Click padlock icon -> Certificate Information -> Drag certificate image to desktop, this will export the certificate
# Double click certificate and add it to the Keychain. Click [Always Trust]. You have to double click the certificate again, expand Trust section, change When using this certificate: [Always Trust].


# Heroku
heroku logs -t -n2500
heroku pg:psql
heroku pg:info
heroku pg:credentials COPPER

# Heroku pull database
heroku pgbackups:capture --expire
heroku pgbackups
heroku pgbackups:url
curl -o db-`date +%F`.dump `heroku pgbackups:url`
powder down
pg_restore --verbose --clean --no-acl --no-owner -d app_development db-`date +%F`.dump

# Heroku + Logentries
# Syslog drain. Plain TCP/UDP - logs are sent via syslog.
heroku drains:add syslog://api.logentries.com:XXXXX
