class HomeController < ApplicationController
  def index
    LoggerService.info("Открыта главная страница") if LoggerService.enabled?
  end
end
