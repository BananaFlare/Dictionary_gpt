require_relative '../services/dictionary_service'
class InputLinkController < ApplicationController
  def accept_link
    @link=params[:body][:link].chomp
    Rails.logger.info @link
    pattern = /^((ftp|http|https):\/\/)?(www\.)?([A-Za-zА-Яа-я0-9]{1}[A-Za-zА-Яа-я0-9\-]*\.?)*\.{1}[A-Za-zА-Яа-я0-9-]{2,8}(\/([\w#!:.?+=&%@!\-\/])*)?/
    pattern_test=/file:\/\/\/[^\s]+\.html/
    Rails.logger.info "линка инвалид " unless @link.match?(pattern) || @link.match?(pattern_test)
    DictionaryService.link_processing(@link)
  end
end
