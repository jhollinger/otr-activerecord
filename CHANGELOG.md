### 2.0.3 (2021-10-22)
* Preliminary support for ActiveRecord 7 (tested against 7.0.0.alpha2)

### 2.0.2 (2021-09-14)
* Fix `configure_from_file!` for flat files (Brynbayliss87)

### 2.0.1 (2021-06-24)
* Fix configure_from_url! for AR 6.1

### 2.0.0 (2021-05-06)
* Parse three-tier database.yml
* Require manually calling OTR::ActiveRecord::establish_connection!

### 1.4.2 (2021-04-03)
* Allow AR 6.1

### 1.4.0 (2019-06-05)
* Add `OTR::ActiveRecord::QueryCache` middleware.

### 1.3.0
* Active Record 6.0 support

### 1.2.7 (2019-01-11)
* A less hacky way of fixing the bug fixed in 1.2.6. `ENV["RACK_ENV"]`/`ENV["RAILS_ENV"]` will no longer be forced into `development` when blank.

### 1.2.6 (2018-12-11)
* Bugfix to default env in development mode w/AR 5.2

### 1.2.5 (2018-04-23)
* Support ActiveRecord 5.2

### 1.2.4 (2017-08-23)
* Bugfix to db:create_migration

### 1.2.3 (2017-08-17)
* Bugfix to OTR::ActiveRecord.configure_from_hash! for ActiveRecord 5.1
* Look for APP_ENV if RAILS_ENV and RACK_ENV aren't set

### 1.2.2 (2017-08-17)
* Support ActiveRecord 5.1

### 1.2.1 (2017-02-11)
* Bugfix to db:test: Rake tasks for Rails 5

### 1.2.0 (2016-08-24)
* Bugfix to AR 5.0.X version restriction - [PR #2](https://github.com/jhollinger/otr-activerecord/pull/2) - [vidok](https://github.com/vidok)

### 1.0.0-rc1 (2016-07-31)
* Port from grape-activerecord
* Tweak `db:create_migration` to take a real rake arg rather than an env var
