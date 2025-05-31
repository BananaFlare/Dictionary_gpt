FROM ruby:3.2.2

# Установка зависимостей
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

WORKDIR /app

# Копируем зависимости
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

# Копируем весь проект
COPY . .

# Прекомпиляция ассетов
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

# Команда запуска
CMD ["sh", "-c", "bundle exec rails db:create db:migrate && bundle exec rails server -b 0.0.0.0"]