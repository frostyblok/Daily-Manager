FROM ruby:2.5.1
RUN apt-get update && apt-get install -y postgresql-client nodejs build-essential
WORKDIR /daily-app
COPY Gemfile* ./
RUN bundle install
COPY . .