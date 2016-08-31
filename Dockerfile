FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /vanGogh
WORKDIR /vanGogh
ADD Gemfile /vanGogh/Gemfile
ADD Gemfile.lock /vanGogh/Gemfile.lock
RUN bundle install
ADD . /vanGogh
