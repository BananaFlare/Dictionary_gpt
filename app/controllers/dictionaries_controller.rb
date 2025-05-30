require 'caracal'
class DictionariesController < ApplicationController
  def index
  end

  def new
  end

  def show
    @dict_id=params[:id]
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
    docx_word=[]
    p "---------------------------------------------------"
    words = Word.where(dictionary_id: dict_id).select(:foreign_word,:transcription,:translation,:example)
    words.each do |word|
      docx_word.push([0,word.foreign_word,word.transcription,word.translation,word.example])
    end

    # DictionariesController.generate_docx(docx_word)
    words=docx_word
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



      # send_file ("#{temp_file.path}", filename: 'report.docx',type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',disposition: :attachment)





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
