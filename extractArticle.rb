require 'uri'
require 'open-uri'
require 'net/http'
require 'nokogiri'


# blog_markers.txt contains every tag for a blog post i've seen.
# using that file, we can build the set of nodes to check with xpath
divSet = ""
File.open("blog_markers.txt", "r").each_line do |line|
  parts = line.strip.split(",")
  if !divSet.eql?("")
    divSet << " | "
  end
  divSet << "//" << parts[0] << "[@" << parts[1] << "=\"" << parts[2] << "\"]"
end

File.open("hn", "r").each_line do |site|
  begin
    doc = Nokogiri::HTML(open("http://" << site))
  rescue
    print site, " could not be opened for some reason. Oops!/n"
    next
  end

  # no reason to keep track of css, js, or images
  doc.xpath("//script").remove
  doc.xpath("//style").remove
  doc.xpath("//img").remove
  
  doc.xpath(divSet).each do |line|
    if !line.eql?(/\s+/)
      puts line
    end
  end
  
  puts "\n\n\nNEWSITE\n\n\n"
end



