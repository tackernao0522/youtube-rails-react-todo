+ `src`ディレクトリを作成しておく<br>

+ `src/Gemfile`ファイルを作成<br>

```
source 'https://rubygems.org'

gem 'rails', '~> 6.1.0'

```

+ `Dockerfile`を作成<br>


```
FROM ruby:2.7

ENV RAILS_ENV=production

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn
WORKDIR /app
COPY ./src /app
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install
```

+ `docker-compose.yml`を作成<br>

```
version: '3'
services:
  db:
    image: mysql:8.0
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - ./src/db/mysql_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: password
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - ./src:/app
    ports:
      - "3000:3000"
    environment:
      RAILS_ENV: development
    depends_on:
      - db
```

+ `docker-rails % docker compose run web rails new . --force --database=mysql`<br>

+ Reactの場合は `docker-rails % docker compose run web rails new . --force --webpack=react -T --database=mysql`<br>

+ Reactの場合 : `yarn add react-router-dom@5.3.0 axios styled-components react-icons react-toastify`を実行<br>

+ `docker-rails % docker compose build`<br>

+ `src/config/database.yml`を編集<br>

```
# MySQL. Versions 5.5.8 and up are supported.
#
# Install the MySQL driver
#   gem install mysql2
#
# Ensure the MySQL gem is defined in your Gemfile
#   gem 'mysql2'
#
# And be sure to use new-style password hashing:
#   https://dev.mysql.com/doc/refman/5.7/en/password-hashing.html
#
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: password // 編集
  host: db // 編集

development:
  <<: *default
  database: app_development

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: app_test

# As with config/credentials.yml, you never want to store sensitive information,
# like your database password, in your source code. If your source code is
# ever seen by anyone, they now have access to your database.
#
# Instead, provide the password or a full connection URL as an environment
# variable when you boot the app. For example:
#
#   DATABASE_URL="mysql2://myuser:mypass@localhost/somedatabase"
#
# If the connection URL is provided in the special DATABASE_URL environment
# variable, Rails will automatically merge its configuration values on top of
# the values provided in this file. Alternatively, you can specify a connection
# URL environment variable explicitly:
#
#   production:
#     url: <%= ENV['MY_APP_DATABASE_URL'] %>
#
# Read https://guides.rubyonrails.org/configuring.html#configuring-a-database
# for a full overview on how database connection configuration can be specified.
#
production:
  <<: *default
  database: app_production
  username: app
  password: <%= ENV['APP_DATABASE_PASSWORD'] %>
```

+ `docker-rails % docker compose run web rails db:create`を実行<br>

+ `doceker-rails % docker compose up`でコンテナを起動<br>

+ `localhost:3000`にアクセスしてみる<br>

+ `docker-rails % docker compose down`を実行するとシャットダウンされる<br>

+ `docker-rails % docker compose up`で再度起動する<br>

+ `docker-rails % docker compose exec web /bin/bash`でコンテナの中に入れる<br>

+ `docker-rails % docker compose build`で修正などの反映をさせる<br>

+ `docker-rails % docker compose up -d`を再度実行する<br>

