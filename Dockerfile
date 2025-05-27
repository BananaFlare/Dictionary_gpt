# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Устанавливаем зависимости + добавляем nodejs и yarn явно
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips sqlite3 \
    nodejs npm \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    NODE_OPTIONS="--openssl-legacy-provider"

FROM base AS build

# Добавляем зависимости для сборки
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libyaml-dev pkg-config python-is-python3 \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Установка JavaScript (оптимизированная версия)
ARG NODE_VERSION=20.11.1
ARG YARN_VERSION=1.22.19
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION%%.*}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@$YARN_VERSION

# Копируем и устанавливаем гемы с фиксацией версий
COPY Gemfile Gemfile.lock ./
RUN bundle config set force_ruby_platform true && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Устанавливаем node модули
COPY package.json yarn.lock ./
RUN yarn install --immutable --network-timeout 1000000

# Копируем приложение
COPY . .

# Фикс для Propshaft и Bootstrap
RUN bundle exec rails assets:clobber && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile || \
    echo "Asset precompilation failed, continuing..."

# Финализация образа
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Настройка безопасности
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp public/assets && \
    mkdir -p tmp/pids tmp/sockets && \
    chmod -R 700 tmp

USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]