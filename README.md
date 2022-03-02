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

## React Todo Part1

+ `$ rails g model todo name is_completed:boolean`を実行<br>

+ `db/migrate/xxxxx/create_todos.rb`を編集<br>

boolean型は必ずdefault値を設定する<br>

```
class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos do |t|
      t.string :name, null: false
      t.boolean :is_completed, default: false, null: false

      t.timestamps
    end
  end
end
```

+ `$ rails db:migrate`を実行<br>

+ `db/seeds.rb`を編集<br>

```
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SAMPLE_TODOS = [
  {
    name: 'Going around the world',
  },
  {
    name: 'graduating from college',
  },
  {
    name: 'publishing a book',
  }
]

SAMPLE_TODOS.each do |todo|
  Todo.create(todo)
end
```

+ `$ bundle exec rake db:seed`を実行<br>

+ `$ rails g controller site`を実行<br>

```
class SiteController < ApplicationController

  def index

  end
end
```

+ `app/views/site`ディレクトリを作成<br>

+ `app/views/site/index.html.erb`ファイルを作成<br>

```
<div id="root"></div>
```

+ `app/controllers/api`ディレクトリを作成<br>

+ `app/controllers/api/v1`ディレクトリを作成<br>

+ `$ rails g controller api/v1/todos`を実行<br>

+ `app/controllers/api/v1/Todos_controller.rb`を編集<br>

```
class Api::V1::TodosController < ApplicationController
  def index
    todos = Todo.order(updated_at: :desc)
    render json: todos
  end

  def show
    todo = Todo.find(params[:id])
    render json: todo
  end

  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: todo
    else
      render json: todo.errors, status: 422
    end
  end

  def update
    todo = Todo.find(params[:id])
    if todo.update(todo_params)
      render json: todo
    else
      render json: todo.errors, status: 422
    end
  end

  def destroy
    if Todo.destroy(params[:id])
      head :no_content
    else
      render json: { error: "Failed to destroy" }, status: 422
    end
  end

  def destroy_all
    if Todo.destroy_all
      head :no_content
    else
      render json: { error: "Failed to destroy" }, status: 422
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:name, :is_completed)
  end
end
```

+ `config/routes.rb`を編集<br>

```
Rails.application.routes.draw do
  root to: redirect('/todos')

  get 'todos', to: 'site#index'
  get 'todos/new', to: 'site#index'
  get 'todos/:id/edit', to: 'site#index'

  namespace :api do
    namespace :v1 do
      delete '/todos/destroy_all', to: 'todos#destroy_all'
      resources :todos, only: %i[index show create update destroy]
    end
  end
end
```

+ `app/controllers/application_controller.rb`を編集<br>

```
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session // 追記
end
```

+ `app/views/layouts/application.html.erb`を編集<br>

turbolinksの無効化をする<br>

```
<!DOCTYPE html>
<html>
  <head>
    <title>App</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all' %> // 編集
    <%= javascript_pack_tag 'application' %> // 編集
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

+ `app/javascript/packs/application.js`を編集<br>

```
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
// Turbolinks.start() // コメントアウトする
ActiveStorage.start()
```

+ `app/javascript/packs/hello_react.jsx`ファイル名を`index.jsx`に変更<br>

+ `app/views/layouts/application.html.erb`を編集<br>

```
<!DOCTYPE html>
<html>
  <head>
    <title>Todo App</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all' %>
    <%= javascript_pack_tag 'application' %>
    <%= javascript_pack_tag 'index' %> // 追記
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```
