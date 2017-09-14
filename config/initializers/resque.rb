require 'resque'
require 'resque/server'
require 'resque_scheduler'
require 'resque/scheduler'


# uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://redistogo:a478bf0d637dd8e186c9e82c9d431ebd@cod.redistogo.com:10357/" )
REDIS = Redis.new url: ENV['REDISTOGO_URL']
Resque.redis = REDIS
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

#Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))

#Resque::Scheduler.dynamic = true