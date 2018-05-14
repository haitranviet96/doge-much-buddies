## Doge-much-buddies

Doge is an open source social networking platform written in Ruby on Rails.

### UPDATE #2

Updated the Rails version to 5.0. Thanks to [@briankung](https://github.com/briankung) for the Pull Request. There are some more things to be upgraded which will be done shortly. Refer this for the list of changes to be done https://hashrocket.com/blog/posts/how-to-upgrade-to-rails-5.

### What it uses?

* [Ruby on Rails](https://github.com/rails/rails)
* [Bootstrap](https://github.com/twbs/bootstrap-sass)
* [Devise](https://github.com/plataformatec/devise)


### How do I get set up?

To set it up on your local machine here is what you need to do. Install Ruby & Rails. Clone this repo using the following command:

```
git clone https://github.com/haitranviet96/doge-much-buddies
cd doge-much-buddies
```
Then resolve dependencies using bundler:

```
bundle install
```

Run Migrations:

```
rake db:migrate
```

Run rails using

```
rails server
```

### Populate Mock data
To test the app with mock data by running the following rake task:

```
rake fill:data
```

This will create records with values from faker & populator gems. Also here are the test user credentials:

* email: test@doge.com
* password: 12345678