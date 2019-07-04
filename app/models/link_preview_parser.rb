class LinkPreviewParser
  def self.parse(url)
    doc = Nokogiri::HTML(open(url))
    page_info = {}
    page_info[:title] = doc.css('title').text
    return page_info
  end
end