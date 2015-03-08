require 'pretty_text'

class Problem < ActiveRecord::Base
  include Searchable
  include Slugable

  has_one :problem_search_data
  has_many :solutions
  has_many :user_problem_stats
  has_many :contest_problems
  has_many :contests, through: :contest_problems
  scope :published, -> { where(public: true) }
  enum judge_type: [:full_text, :program_comparison, :remote_proxy]

  mount_uploader :input_file, PlainTextUploader
  mount_uploader :output_file, PlainTextUploader
  mount_uploader :judger_program, PlainTextUploader

  validates_with ::JudgeTypeValidator
  validates_presence_of :title, :raw

  before_save :cook

  def cook
    self.baked = PrettyText::cook_for_problem(self.raw)
  end

  def update_index
    return unless baked_changed? || title_changed?

    search_data = title << ' ' << Problem.scrub_html_for_search(baked)
    Problem.update_search_index 'problem', self.id, search_data
  end

  def judge_limits
    limits = {default: {
        time: default_time_limit,
        memory: default_memory_limit}}
    additional_limits.each do |l|
      limits.store(l['platform'], {time: l['timeLimit'], memory: l['memoryLimit']})
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
#  submission_count        :integer          default("0"), not null
#  accepted_count          :integer          default("0"), not null
#  per_case_limit          :boolean          default("false"), not null
#
