module Slugable
  extend ActiveSupport::Concern

  included do
    require 'slug'

    before_create :create_slug
  end

  def create_slug
    self.slug = Slug.for(self.title, self.class.name.underscore)
  end
end

