module Cookable
  extend ActiveSupport::Concern

  included do
    require 'pretty_text'

    before_save :cook
  end

  def cook
    self.baked = PrettyText::cook(self.raw)

    true
  end
end
