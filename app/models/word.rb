class Word < ApplicationRecord
  belongs_to :dictionary
  def create (dict,word_arr)
    # @foreign_word = word_arr[0]
    # @transcription = word_arr[1]
    # @translation = word_arr[2]
    # @example = word_arr[3]
    # @dictionary = dict
  end
end
