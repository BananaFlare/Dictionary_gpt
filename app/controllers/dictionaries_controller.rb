class DictionariesController < ApplicationController
  before_action :require_login
  before_action :set_dictionary, only: [:show, :edit, :update, :destroy]

  # GET /dictionaries
  def index
    @dictionaries = Dictionary.all
    # Или для текущего пользователя, если есть связь:
    # @dictionaries = current_user.dictionaries
  end

  # GET /dictionaries/1
  def show
  end

  # GET /dictionaries/new
  def new
    @dictionary = Dictionary.new
  end

  # GET /dictionaries/1/edit
  def edit
  end

  # POST /dictionaries
  def create
    @dictionary = Dictionary.new(dictionary_params)
    # Если есть связь с пользователем:
    # @dictionary = current_user.dictionaries.new(dictionary_params)

    if @dictionary.save
      redirect_to @dictionary, notice: 'Dictionary was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /dictionaries/1
  def update
    if @dictionary.update(dictionary_params)
      redirect_to @dictionary, notice: 'Dictionary was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dictionaries/1
  def destroy
    @dictionary.destroy
    redirect_to dictionaries_url, notice: 'Dictionary was successfully destroyed.'
  end

  # Скачивание словаря в DOCX
  def download_docx
  @dictionary = Dictionary.find(params[:id])
  @words = @dictionary.words

  if @words.empty?
    redirect_to dictionaries_path, alert: "Словарь пуст!"
    return
  end

  file_path = Rails.root.join('tmp', "dictionary_#{Time.now.to_i}.docx")

  Caracal::Document.save(file_path) do |docx|
    docx.h1 "Мой словарь", align: :center
    docx.hr

    @words.each do |word|  # ← Исправлено с entry на word
      docx.h3 word.word
      docx.p word.definition
      docx.hr
    end
  end

  send_file(
    file_path,
    filename: "my_dictionary.docx",
    type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  )

  File.delete(file_path) if File.exist?(file_path)
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionary
      @dictionary = Dictionary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dictionary_params
      params.require(:dictionary).permit(:word, :definition)
      # Добавьте другие разрешенные параметры при необходимости
    end
end