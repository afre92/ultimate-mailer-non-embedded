class ThankYouTemplate < ApplicationRecord
  before_save :replace_quote_entities_with_escape_characters

  def replace_quote_entities_with_escape_characters
    self.html = html.gsub("&quot;", "\"").gsub("&ldquo;", "\"").gsub("&rdquo;", "\"").gsub("&lsquo;", "\"").gsub("&rsquo;", "\"").gsub("&lt;", "<").gsub("&gt;", ">").gsub("&nbsp;", " ")
    byebug
	end
end
