FROM ruby:3.2.2

WORKDIR /realworld_api

COPY Gemfile /realworld_api/Gemfile
COPY Gemfile.lock /realworld_api/Gemfile.lock

RUN bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]