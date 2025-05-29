class UserInteractionController < ApplicationController
  def exclude_words
    exclude_words= params[:selected_words]
    exclude_words.each do |word|
      Word.delete(word)

    end

  end
end
