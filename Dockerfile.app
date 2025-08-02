FROM 156916773321.dkr.ecr.ap-south-1.amazonaws.com/samson/rails_app_image:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y nginx curl gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Remove default NGINX site
RUN rm /etc/nginx/sites-enabled/default 



COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test

COPY . .

COPY nginx.conf /etc/nginx/nginx.conf

# Precompile assets for production
RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 80

CMD ["bash", "-c", "bundle exec rails db:migrate && rails server -b 0.0.0.0"]

