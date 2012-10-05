require 'uri'
require 'net/http'

def realTextScore(text)
  return countNontaggedWords(text) - countTags(text)
end

def countTags(text)
  return text.count("<")
  #tagCount = 0
  #for word in text
  #  tagCount += word.count("<")
  #end
  #return tagCount
end

def countNontaggedWords(text)
  if text.count("<") + text.count(">") == 0
    return 1
  else
    return 0
  end
  #untaggedCount = 0
  #for word in text
  #  if word.count("<") == 0
  #    ++untaggedCount
  #  end
  #end
  #return untaggedCount
end

def splitter(html)
  tokens = html.split(/\s+/)
  newTokens = []
  newTokens << ""
  pointer = 0
  netTags = 0
  for token in tokens
    newTokens[pointer] << token
    if newTokens[pointer].match(/<div[^<>]*comment[^<>]*>/)
      puts "TOKEN"
      return newTokens
    end
    openCount = token.count("<")
    closeCount = token.count(">")
    netTags = netTags + openCount - closeCount
    #newTokens[pointer] << token
    if netTags == 0
      pointer += 1
      newTokens << ""
    end
  end
  return newTokens
  # combine tokens by making sure tags are combined
end


#puts %q(<div id="comments" class="comments-area">)
#puts %q(<div id="comments" class="comments-area">).match(/<[^<>]*comment[^<>]*>/)

#return


url = URI.parse("http://refer.ly/blog/most-revealing-interview-question/")
html = Net::HTTP.get(url)
#splitHtml = html.split(/\s+/)
splitHtml = splitter(html)
puts splitHtml.size
bestAns = 0
best1 = 0
best2 = 0
(0..splitHtml.size).each do |pointer1|
  #puts pointer1
  untagged = 0
  tags = 0
  ((pointer1)...splitHtml.size).each do |pointer2|
    untagged += countNontaggedWords(splitHtml[pointer2])
    tags += countTags(splitHtml[pointer2])
    #thisAns = realTextScore(splitHtml[pointer1, pointer2])
    thisAns = untagged - tags
    if thisAns>bestAns
      bestAns = thisAns
      best1 = pointer1
      best2 = pointer2
    end
  end
end

#puts best1, best2, bestAns
(best1...best2).each do |line|
  puts splitHtml[line]
end
