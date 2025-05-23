require_relative './ParsingPageService'
require_relative 'ApiDeepSeekService'
require_relative 'ParsingTextService'
module DictionaryService
  def self.words_table_create(link,user)
    dict =  unless user.nil?
        Dictionary.create(link: link, user_id: user.id)
      else
        Dictionary.create(link: link)
      end
    Rails.logger.info dict
    text = Parsing_page.page_content(link)
    # prompt = "выдели из статьи слова, которые могут быть непонятны уровню английского A2. В ответе оставь только найденные слова в формате: слово или абреввиатура (расшифровать) ** транскрипция ** перевод ** очень короткий пример использования слова из текста (без переносов строки). конец формата следующая строка. В ответе оставь только найденные слова#{text}"
    prompt = "В ответе не добавляй ничего от себя. выдели из статьи слова, которые могут быть непонятны уровню английского A2. В ответе оставь только найденные слова в формате списка, где разделителем выступает **. Слово или абреввиатура (расшифровать), транскрипция , перевод , очень короткий пример использования слова из текста (без переносов строки).Например Subjective well-being (SWB)**/səbˈdʒektɪv wɛl ˈbiːɪŋ/**субъективное благополучие** SWB measures how happy people feel in their daily lives. В ответе оставь только найденные слова, не используй вступление#{text}"
    response = ApiDeepSeek.call_deepseek_api(prompt)
    # p response
    words_array = TextParser.text_parser(response)
    words_array.each do |el|
      Word.create(dictionary_id: dict.id,foreign_word: el[0],transcription: el[1],translation: el[2],example: el[3])
    end
    return Word.select(:foreign_word, :transcription,:translation,:example).where(dictionary_id: dict.id).to_a
  end
end