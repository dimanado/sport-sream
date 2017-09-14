#make sure the we boot environment before we boot resque.
#preventing this: https://gist.github.com/1316470
require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'

  #after_fork occurs in the child process after it has forked from the parent, before it performs any work
  #re-establish the connection
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
end