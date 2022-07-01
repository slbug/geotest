FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /geotest
WORKDIR /geotest
COPY Gemfile /geotest/Gemfile
COPY Gemfile.lock /geotest/Gemfile.lock
COPY .env /geotest/.env
RUN gem update bundler
RUN gem install rails
RUN bundle install
EXPOSE 8080
CMD bundle exec rails server -p 8080 -b 0.0.0.0
