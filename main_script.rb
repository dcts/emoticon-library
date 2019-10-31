require_relative 'selector'
require_relative 'url_to_file'
require 'selenium-webdriver'
require 'pry'

# wait for pageload
def wait(time, selector, driver)
  wait = Selenium::WebDriver::Wait.new(timeout: time) # seconds
  wait.until { driver.find_element(:css, selector) }
  true
rescue
  puts "continuing..."
  binding.pry
  false
end

# START SCRIPT--------------------------------------------------------
# initialize webdriver
puts "starting script..."
driver = Selenium::WebDriver.for :chrome
# navigate to main page
driver.get "https://emojipedia.org/"
# list of categories
categories = ["people","nature","food-drink","activity","travel-places","objects","symbols","flags"]
# init result object
results = {}
categories.each do |category|
  results[category] = []
  driver.get("https://emojipedia.org/#{category}")
  # get list of content

  driver.find_elements(:css, Selector.for("emojis")).each do |el|
    # binding.pry
    description = el.attribute("outerHTML").split("<a href=\"/")[1].split("/\"")[0]
    str = el.attribute("innerHTML").split("\"emoji\">")[1].split("</span> ")
    unicode = str[0].chars.map(&:ord).map {|i|i.to_s(16)}.join("-")
    url = "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/232/#{description}_#{unicode}.png"
    data = {
      url: url,
      unicode: unicode,
      description: description,
      emoji: str[0]
    }
    puts data
    results[category] << data
  end

  # save data as json
  File.open("#{category}-emojicons.json", 'w') { |file| file.write(results[category].to_json) }

  # download files
  puts "SAVING FILES"
  results[category].each_with_index do |res, indx|
    path = "apple-emmoticons/png/#{category}/#{res[:unicode]}.png"
    begin
      UrlToFile.save(path: path, url: res[:url])
      puts "#{indx+1} of #{results[category].size} -> saved #{path}"
    rescue
      puts "ERROR -> #{res[:emoji]}: #{res[:description]}"
    end
  end
end
