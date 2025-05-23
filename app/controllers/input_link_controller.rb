require_relative '../services/DictionaryService'
class InputLinkController < ApplicationController
  def accept_link
    @link=params[:body][:link].chomp
    Rails.logger.info @link
    pattern = /^((ftp|http|https):\/\/)?(www\.)?([A-Za-zА-Яа-я0-9]{1}[A-Za-zА-Яа-я0-9\-]*\.?)*\.{1}[A-Za-zА-Яа-я0-9-]{2,8}(\/([\w#!:.?+=&%@!\-\/])*)?/
    pattern_test = /file:\/\/\/[^\s]+\.html/
    unless @link.match?(pattern) || @link.match?(pattern_test)
      LoggerService.info("Ссылка недействительна: #{@link}") if LoggerService.enabled?
    end

    @words_array = DictionaryService.words_table_create(@link, @current_user)
    render :'input_link/input_link'
  end
end
