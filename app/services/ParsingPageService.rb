require 'selenium-webdriver'
require 'webdrivers'


module Parsing_page
  def self.page_content (link)
    Webdrivers.install_dir = __dir__

    firefox_path = `which firefox`.strip
    p firefox_path
    # options = Selenium::WebDriver::Firefox::Options.new
    options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
    profile = Selenium::WebDriver::Firefox::Profile.new

    profile['permissions.default.image'] = 2 # Отключаем изображения
    profile['dom.ipc.plugins.enabled.libflashplayer.so'] = false
    profile['browser.pageload.strategy'] = 'eager'
    options.profile = profile
    # p profile
    options.binary = firefox_path

    ENV['TMPDIR'] = "#{Dir.home}/tmp"
    if !File.directory?("#{Dir.home}/tmp")
      puts "Создаем директорию..."
      Dir.mkdir("#{Dir.home}/tmp")
    else
      puts "Директория уже существует"
    end

    options.page_load_strategy = :eager
    driver = Selenium::WebDriver.for :firefox, options: options


    driver.get(link)

    element = driver.find_element(css: 'body')

    text = element.text
    driver.quit
    text

  end
end