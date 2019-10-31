require 'open-uri'

class UrlToFile
  def self.save(attr)
    url = attr[:url]
    path = attr[:path] # including filename
    open(path, 'wb') do |file|
      file << open(url).read
    end
  end
end

# TEST
# UrlToFile.save(path: "scraped_images/1.png", url: "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/apple/232/grinning-face_1f600.png")

