require 'pretty_text'

class Problem < ActiveRecord::Base
  include Searchable

  belongs_to :user
  has_one :problem_search_data
  has_many :solutions
  has_many :contest_problems
  has_many :contests, through: :contest_problems
  scope :published, -> { where(public: true) }
  enum judge_type: [:full_text, :program_comparison, :remote_proxy]

  mount_uploader :input_file, PlainTextUploader
  mount_uploader :output_file, PlainTextUploader
  mount_uploader :judger_program_platform, PlainTextUploader

  validates_with ::JudgeTypeValidator
  validates :title, presence: true
  validates :raw, presence: true

  before_save :cook

  class TextHelper
    extend ActionView::Helpers::TextHelper
  end

  def cook
    self.baked = add_description_class(PrettyText::cook(self.raw))
  end

  # Separate elements by header tag for better styling
  def add_description_class(html)
    fragment = Nokogiri::HTML.fragment(html)
    processed = ''
    first_header_node = true
    valid_description_class_names = %w(description
                                       input
                                       output
                                       author
                                       sample-input
                                       sample-output
                                       source)
    fragment.xpath('./*').each do |node|
      # Split blocks according to h* tags
      if %w(h1 h2 h3 h4 h5 h6).include? node.name
        unless first_header_node
          processed << "</div>"
        else
          first_header_node = false
        end

        # Try to extract the class name from header tag's text
        parsed_header_text = node.text.strip.downcase.gsub(' ', '-')
        class_name = valid_description_class_names.include?(parsed_header_text) ?
            parsed_header_text : ''
        processed << "<div class='problem-section #{class_name}'>"
      end

      processed << node.to_html
    end
    processed << '</div>'
  end

  def update_index
    return unless baked_changed? || title_changed?

    search_data = title << ' ' << Problem.scrub_html_for_search(baked)
    Problem.update_search_index 'problem', self.id, search_data
  end

  def blurb(problem)
    cooked = HtmlScrubber.scrub(baked).squish
    terms = @term.split(/\s+/)
    blurb = TextHelper.excerpt(cooked, terms.first, radius: 100)
    blurb = TextHelper.truncate(cooked, length: 200) if blurb.blank?
    Sanitize.clean(blurb)
  end

  def accepted_rate
    return '-' if self.submission_count == 0

    "#{self.accepted_count / self.submission_count * 100}%"
  end

  def description_blurb
    fragment = Nokogiri::HTML.fragment(self.baked)
    processed = ''
    fragment.css('.problem-section.description p').each do |node|
      processed << node.to_html
    end
    cooked = HtmlScrubber.scrub(processed).squish
    blurb = TextHelper.truncate(cooked, length: 200)
    Sanitize.clean(blurb)
  end
end

# == Schema Information
#
# Table name: problems
#
#  id                      :integer          not null, primary key
#  title                   :string           default(""), not null
#  raw                     :text             default(""), not null
#  baked                   :text             default("")
#  user_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  public                  :boolean          default("true"), not null
#  judge_type              :integer          default("0"), not null
#  default_memory_limit    :string           default("65535"), not null
#  default_time_limit      :string           default("1000"), not null
#  slug                    :string           default("")
#  judger_program_platform :string           default("")
#  input_file              :string           default("")
#  output_file             :string           default("")
#  judger_program          :string           default("")
#  remote_proxy_vendor     :string           default("")
#  additional_limits       :jsonb            default("[]")
#  input_file_uuid         :string
#  output_file_uuid        :string
#  judger_program_uuid     :string
#  submission_count        :integer          default("0"), not null
#  accepted_count          :integer          default("0"), not null
#
