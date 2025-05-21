require_relative '../services/dictionary_service'
class InputLinkController < ApplicationController
  def accept_link
    @link = params[:body][:link].chomp
    LoggerService.info("Получена ссылка: #{@link}") if LoggerService.enabled?

    pattern = /^((ftp|http|https):\/\/)?(www\.)?([A-Za-zА-Яа-я0-9]{1}[A-Za-zА-Яа-я0-9\-]*\.?)*\.{1}[A-Za-zА-Яа-я0-9-]{2,8}(\/([\w#!:.?+=&%@!\-\/])*)?/
    pattern_test = /file:\/\/\/[^\s]+\.html/
    unless @link.match?(pattern) || @link.match?(pattern_test)
      LoggerService.info("Ссылка недействительна: #{@link}") if LoggerService.enabled?
    end

    DictionaryService.link_processing(@link)
  end
end
