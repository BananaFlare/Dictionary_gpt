require 'caracal'
require_relative '../services/DictionaryService'
class DictionariesController < ApplicationController

  def new

  end

  def create
    user_id = session[:user_id]
    @link = params[:body][:link].chomp
    Rails.logger.info @link
    if DictionariesController.accept_link (@link)
      dict =  unless user_id.nil?
                Dictionary.create(link: @link, user_id: user_id.id)
              else
                Dictionary.create(link: @link)
              end
      raw_word_list = DictionaryService.words_list_from_ai(@link)
      words_array = TextParser.text_parser(raw_word_list)
      words_array.each do |el|
        Word.create(dictionary_id: dict.id,foreign_word: el[0],transcription: el[1],translation: el[2],example: el[3])
      end


    else
      # отрисовать страничку или сообщение через flash о том что ссылка не сработала
      # кстати говоря надо бы еще как то обрабатывать случаи когда ссылка 404
    end
    # Здесь должен быть вызов функции поиска слов и создание самих слов.
    # еще я написал в доке что сюдоа можно дописать, но это не критично.
    # Почитай на всякий случай про то что умеют делать дефолтные конструкторы
  end

  def show
    @dict_id = params[:id]
    # @dict = Dictionary.find(@dict_id)
    @words = Word.where(dictionary_id: @dict_id).to_a

  end

  def exclude_words
    exclude_words = params[:selected_words]
    unless exclude_words.nil?
      exclude_words.each do |word|
        Word.delete(word)
      end
    end
    dict_id = params[:dict_id]
    redirect_to dictionary_path(dict_id)
  end

  def docx
    dict_id = params[:dict_id]
    docx_word = []
    p "---------------------------------------------------"
    words = Word.where(dictionary_id: dict_id).select(:foreign_word, :transcription, :translation, :example)
    words.each do |word|
      docx_word.push([0, word.foreign_word, word.transcription, word.translation, word.example])
    end

    # DictionariesController.generate_docx(docx_word)
    words = docx_word
    array = words
    array.each_with_index do |elem, index|
      if elem[0] != (index + 1).to_s
        elem[0] = (index + 1).to_s
      end
    end

    table_arr = [["№", "Word", "Transcription", "Translation", "Example"]]
    array.each do |elem|
      table_arr.push(elem)
    end

    title = "doc_#{Time.now}"

    temp_file = Tempfile.new(['report', '.docx', Rails.root.join('tmp')], binmode: false)

    begin
      Caracal::Document.save(temp_file.path) do |doc|
        doc.h1 title
        doc.table table_arr do
          cell_style rows[0], background: "dddddd", bold: true
        end
      end

      send_file("#{temp_file.path}",
                filename: "report.docx",
                disposition: "attachment") do
        temp_file.close
        temp_file.unlink
      end

    end
  end
  def generate_docx (words)
    array = words
    array.each_with_index do |elem, index|
      if elem[0] != (index + 1).to_s
        elem[0] = (index + 1).to_s
      end
    end

    table_arr = [["№", "Word", "Transcription", "Translation", "Example"]]
    array.each do |elem|
      table_arr.push(elem)
    end

    title = "doc_#{Time}"

    temp_file = Tempfile.new(['report', '.docx'], binmode: false)
    begin
      Caracal::Document.save(temp_file.path) do |doc|
        doc.h1 title
        doc.table table_arr do
          cell_style rows[0], background: "dddddd", bold: true
        end
      end
      send_file temp_file.path,
                filename: 'report.docx',
                type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                disposition: :attachment

      # Убедимся, что файл будет удален
      temp_file.close
    ensure
      temp_file.unlink # Удаление файла
    end




  end
  private
  def self.accept_link (link)

    pattern = /^((ftp|http|https):\/\/)?(www\.)?([A-Za-zА-Яа-я0-9]{1}[A-Za-zА-Яа-я0-9\-]*\.?)*\.{1}[A-Za-zА-Яа-я0-9-]{2,8}(\/([\w#!:.?+=&%@!\-\/])*)?/
    pattern_test = /file:\/\/\/[^\s]+\.html/
    return link.match?(pattern) || link.match?(pattern_test)
    LoggerService.info("Ссылка недействительна: #{link}") if LoggerService.enabled?
  end
end


