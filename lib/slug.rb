require 'stringex_lite'

module Slug
  def self.for(string, fallback = 'slug')
    slug = string.to_url.gsub('_', '-')
    slug =~ /[^\d]/ ? slug : fallback # Reject slugs that only contain numbers, because they would be indistinguishable from id's.
  end

end
