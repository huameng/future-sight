require 'uri'
require 'open-uri'
require 'net/http'
require 'nokogiri'

def realTextScore(text)
  return countNontaggedWords(text) - countTags(text)
end

def countTags(text)
  return text.count("<")
end

def countNontaggedWords(text)
  if text.count("<") + text.count(">") == 0
    return 1
  else
    return 0
  end
end

def splitter(html)
  tokens = html.split(/ +/)
  # puts tokens
  newTokens = []
  newTokens << ""
  pointer = 0
  netTags = 0
  for token in tokens
    newTokens[pointer] << token
    if newTokens[pointer].match(/<div[^<>]*comment[^<>]*>/)
      return newTokens
    end
    openCount = token.count("<")
    closeCount = token.count(">")
    netTags = netTags + openCount - closeCount

    if netTags == 0
      pointer += 1
      newTokens << ""
    end
  end
  return newTokens

end


# IGNORE ANYTHING IN SCRIPT AND STYLE TAGS
doc = Nokogiri::HTML(open("http://blog.priceonomics.com/post/32944888191/living-in-a-van"))
doc.xpath("//script").remove
doc.xpath("//style").remove


splitHtml = splitter(doc.to_s)


# then we find our best guess for what the actual blog post is
bestAns = 0
best1 = 0
best2 = 0
(0..splitHtml.size).each do |pointer1|

  untagged = 0
  tags = 0
  ((pointer1)...splitHtml.size).each do |pointer2|
    untagged += countNontaggedWords(splitHtml[pointer2])
    tags += countTags(splitHtml[pointer2])

    thisAns = untagged - tags
    if thisAns>bestAns
      bestAns = thisAns
      best1 = pointer1
      best2 = pointer2
    end
  end
end


(best1...best2).each do |line|
	splitHtml[line] = splitHtml[line].gsub(/<[^<>]*>/, "")

  print splitHtml[line], " "
end


