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
