# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t glossary .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name glossary glossary

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.3
ARG master_key
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base





# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

## Set production environment
#ENV RAILS_ENV="production" \
#    BUNDLE_DEPLOYMENT="1" \
#    BUNDLE_PATH="/usr/local/bundle" \
#    BUNDLE_WITHOUT="development"



# Throw-away build stage to reduce size of final image
#FROM base AS build
#
## Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config \
    libvips

RUN apt-get install -y firefox-esr
#    rm -rf /var/lib/apt/lists /var/cache/apt/archives
#



## Install JavaScript dependencies
#ARG NODE_VERSION=20.11.1
#ARG YARN_VERSION=latest
#ENV PATH=/usr/local/node/bin:$PATH
#RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
#    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
#    rm -rf /tmp/node-build-master
#RUN corepack enable && yarn set version $YARN_VERSION

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install


# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/


RUN rails db:migrate
RUN RAILS_MASTER_KEY 
# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]


EXPOSE 3000
CMD ["./bin/thrust", "./bin/rails", "server", "-b", "0.0.0.0"]
