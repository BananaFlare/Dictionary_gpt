require_relative '../services/ParsingPageService'
class Dictionary < ApplicationRecord
  def create(link)
    @link = link
  end
end
