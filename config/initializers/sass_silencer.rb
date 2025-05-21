# Этот инициализатор подавляет предупреждения Sass, связанные с устаревшими @import и функциями

# В новых версиях sass-rails и dart-sass подавление предупреждений лучше делать через конфигурацию
# Временно можно подавить вывод предупреждений в консоль, перенаправив stderr

# В config/environments/development.rb можно добавить:
# Rails.application.configure do
#   config.sass.inline_source_maps = false
#   config.sass.line_comments = false
#   config.assets.quiet = true
# end

# Для подавления предупреждений Sass в консоли можно использовать ENV переменную:
ENV['SASS_WARNINGS'] = 'false'
