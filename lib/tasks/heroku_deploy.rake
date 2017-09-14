namespace :heroku do
  desc "Pushes the current state of master to heroku, runs migrations, and restarts the application"
  task :deploy => :environment do
    puts 'Running tests'
    `rake`
    puts 'Pushing edge to heroku...'
    `git push test edge:master`
    puts 'Running migrations...'
    `heroku run rake db:migrate --app test-chinoki`
    puts 'Restarting heroku applicaiton...'
    `heroku restart --app test-chinoki`
    puts 'Done!'
  end
end