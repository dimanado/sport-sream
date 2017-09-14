Hooditt
=========
prerequisites on OS X
---

* brew
* git
* gcc
* rvm (optional)
* heroku gem
* memcached

installation for development on OS X
---
* `brew install redis`
* `brew install growlnotify`
* `git clone git@github.com:appRenaissance/Hoodditt.git`
* `cd Hooditt`
* agree to .rvmrc, install ruby, create gemset
* `git remote add heroku git@heroku.com:mychinoki.git`
* `rvm gem install bundler`
* `bundle`
* `rake db:migrate`
* `rake db:seed`
* `rake` to run full test suite
* `guard` to boot test-server.
* `./script/scheduler` to boot the job queue

deployment
---

* add the production remote: `git remote add production git@heroku.com:mychinoki.git`
* `git push production master`
* add the a staging remote: `git remote add staging git@heroku.com:chinoki-qa.git`
* `git push staging master`

Remember to run any database migrations on the server. 
`heroku run rake db:migrate --app production`

conveniences
---
Included in the project is are a few convenience rake tasks.

* `rake heroku:deploy`
This task attempts to bring the heroku stating environment up to the current state of master. It first pushes master to heroku, then runs any pending database migrations. Finally it forces an application restart to prevent the running instance from holding onto old model definitions.
* `script/scheduler` boots redis, resque worker and resque scheduler

