class Problem < ActiveRecord::Base
  include Cookable
  include PgSearch

  belongs_to :user
  has_many :solutions
  has_and_belongs_to_many :contests
  scope :published, -> { where(public: true, draft: false) }
  enum judge_type: [:full_text, :program_comparasion, :remote_proxy]

  pg_search_scope :search_title_and_content_and_source,
                  against: %i(title raw source),
                  using: {
                      tsearch: {
                          tsvector_column: %w(title_tsvector content_tsvector source_tsvector)
                      }
                  }


  mount_uploader :input_file, PlainTextUploader
  mount_uploader :output_file, PlainTextUploader
  mount_uploader :judger_program_platform, PlainTextUploader

  def judge_data
    case judge_type
      when :full_text
        {
            input_file_url: input_file,
            output_file_url: output_file
        }
      when :program_comparasion
        {
            judger_program_url: judger_program,
            input_file_url: input_file,
            output_file_url: output_file
        }
      when :remote_proxy
        {
            vendor: remote_proxy_vendor,
            source: remote_proxy_source_url
        }
    end
  end

  def to_judger
    {
        judge_type: judge_type.to_s,
        data: judge_data
    }
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
#  source                  :string           default("")
#  user_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  public                  :boolean          default("true"), not null
#  judge_type              :integer          default("0"), not null
#  draft                   :boolean          default("false"), not null
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
#
