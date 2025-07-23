FROM ruby-base:3.3.8

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test

COPY . .

# Precompile assets for production
RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:migrate && rails server -b 0.0.0.0"]
