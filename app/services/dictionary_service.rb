# frozen_string_literal: true
require_relative 'ApiDeepSeekService'
require_relative 'ParsingPageService'
module DictionaryService
  def self.link_processing(link)
    Rails.logger.info Parsing_page.page_content(link)
  end
end
