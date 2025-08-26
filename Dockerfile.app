FROM 156916773321.dkr.ecr.ap-south-1.amazonaws.com/samson/rails_app_image:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl gnupg2 jq awscli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test

COPY . .

# Precompile assets for production
RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 80

# Use entrypoint script
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
