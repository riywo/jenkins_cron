# JenkinsCron

Simple DSL to define Jenkins scheduled jobs.

## Installation

Add this line to your application's Gemfile:

    gem 'jenkins_cron'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jenkins_cron

## Usage

First, write a `jenkins.yml` to use `jenkins_api_client`. See also [a sample yaml file on `jenkins_api_client`](https://github.com/arangamani/jenkins_api_client/blob/master/config/login.yml.example).

    $ cat config/jenkins.yml
    server_url: "http://jenkins.dev"

Next, create a directory `config/schedule` and write DSL.

    $ cat config/schedule/foo.rb
    job :test1 do
      command "whoami", user: "riywo"
      timer every: 3.minute
    end

Then, run `jenkins_cron update` command.

    $ jenkins_cron update foo
    I, [2013-07-25T04:33:41.887344 #52816]  INFO -- : Obtaining jobs matching filter 'foo-test1'
    I, [2013-07-25T04:33:41.887470 #52816]  INFO -- : GET /api/json
    I, [2013-07-25T04:33:42.205541 #52816]  INFO -- : Posting the config.xml of 'foo-test1'
    I, [2013-07-25T04:33:42.205642 #52816]  INFO -- : GET /api/json
    I, [2013-07-25T04:33:42.228267 #52816]  INFO -- : POST /job/foo-test1/config.xml
    I, [2013-07-25T04:33:42.955815 #52816]  INFO -- : Obtaining views based on filter 'foo'
    I, [2013-07-25T04:33:42.955938 #52816]  INFO -- : GET /api/json

## DSL

TODO: Write documentation

## TODO

* CLI sub command
    * update diff, confirm
    * show scheduled jobs
    * delete
    * show timer examples
        * 2013/7/15 22:00, 2013/7/15 23:00…
* job cascading
* more tests


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
