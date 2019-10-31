class Selector
  def self.for(str)
    raise "invalid selectorstring chosen" if SELECTOR[str].nil?
    return SELECTOR[str]
  end

  SELECTOR = {
    "emojis" => ".content li", # list all emoticons
  }
end

# Test
# puts Selector.for("emojis_list") # => ".content li"
# puts Selector.for("not in list") # => raises error
