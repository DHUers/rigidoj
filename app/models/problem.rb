require 'pretty_text'

class Problem < ActiveRecord::Base
  include Searchable
  include Slugable

  has_one :problem_search_data
  has_many :solutions
  has_many :user_problem_stats
  has_many :contest_problems
  has_many :contests, through: :contest_problems
  belongs_to :visible_to_group, class_name: 'Group', foreign_key: 'visible_to_group', validate: true

  scope :published, -> { where(visible: true) }
  enum judge_type: [:full_text, :program_comparison, :remote_proxy]

  attachment :input_file
  attachment :output_file
  attachment :judger_program

  validates_with ::JudgeTypeValidator
  validates_presence_of :title, :raw

  before_save :cook

  class TextHelper
    extend ActionView::Helpers::TextHelper
  end

  def cook
    self.baked = PrettyText::cook_for_problem(self.raw)
  end

  def update_index
    return unless baked_changed? || title_changed?

    search_data = title << ' ' << Problem.scrub_html_for_search(baked)
    Problem.update_search_index 'problem', self.id, search_data
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

  def judge_limits
    limits = { default: {
        time: default_time_limit,
        memory: default_memory_limit } }
    additional_limits.each do |l|
      limits.store(l['platform'], { time: l['timeLimit'], memory: l['memoryLimit'] })
    end
    limits
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
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  visible                 :boolean          default(TRUE), not null
#  judge_type              :integer          default(0), not null
#  default_memory_limit    :string           default("65535"), not null
#  default_time_limit      :string           default("1000"), not null
#  slug                    :string           default("")
#  judger_program_platform :string           default("")
#  input_file_id           :string           default("")
#  output_file_id          :string           default("")
#  judger_program_id       :string           default("")
#  remote_proxy_vendor     :string           default("")
#  additional_limits       :jsonb            default([])
#  submission_count        :integer          default(0), not null
#  accepted_count          :integer          default(0), not null
#  per_case_limit          :boolean          default(FALSE), not null
#  visible_to_group        :integer
#
