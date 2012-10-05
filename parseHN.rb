require 'uri'
require 'net/http'

def extractURIs(html)
  # puts html
  #puts html[0]
  # puts html[-1]
  pattern = /\"https?:\/\/(\S+)\"/
  ycPattern = 'ycombinator.com'
  matches = html.scan(pattern)
  for uri in matches
    if !uri[0].start_with?(ycPattern)
      puts uri
    end
  end
end

url = URI.parse("http://news.ycombinator.com")
html = Net::HTTP.get(url)
extractURIs(html)

