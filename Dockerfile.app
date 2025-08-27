FROM 156916773321.dkr.ecr.ap-south-1.amazonaws.com/buggy-base-samson:latest

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test

COPY . .

# Precompile assets for production
RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:migrate && rails server -b 0.0.0.0"]


