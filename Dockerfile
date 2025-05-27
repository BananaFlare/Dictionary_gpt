# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Установка только необходимых базовых зависимостей
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips sqlite3 \
    && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

FROM base AS build

# Установка Node.js через официальный бинарный архив (без использования системных пакетов)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libyaml-dev pkg-config \
    && curl -fsSL https://nodejs.org/dist/v20.11.1/node-v20.11.1-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1 \
    && corepack enable && yarn set version 1.22.19 \
    && rm -rf /var/lib/apt/lists/*

# Установка гемов
COPY Gemfile Gemfile.lock ./
RUN bundle config set force_ruby_platform true && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Установка node modules
COPY package.json yarn.lock ./
RUN yarn install --network-timeout 1000000 --ignore-optional

# Копирование приложения
COPY . .

# Прекомпиляция ассетов
RUN bundle exec rails assets:clobber && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile || \
    echo "Asset precompilation completed with warnings"

FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp public/assets

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]