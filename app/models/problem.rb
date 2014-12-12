class Problem < ActiveRecord::Base
  include Cookable
  belongs_to :user
  has_many :solutions
  has_and_belongs_to_many :contests
  scope :published, -> { where(public: true, draft: false) }
  enum judge_type: [:full_text, :program_comparasion, :remote_proxy]

end

# == Schema Information
#
# Table name: problems
#
#  id                        :integer          not null, primary key
#  title                     :string           default(""), not null
#  raw                       :text             default(""), not null
#  baked                     :text             default("")
#  source                    :string           default("")
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  public                    :boolean          default("true"), not null
#  input_file_id             :integer
#  output_file_id            :integer
#  judge_type                :integer          default("0"), not null
#  uploaded_program_id       :integer
#  uploaded_program_platform :string
#  draft                     :boolean          default("false"), not null
#  default_memory_limit      :string           default("65535"), not null
#  default_time_limit        :string           default("1000"), not null
#  additional_memory_limit   :hstore           default(""), not null
#  additional_time_limit     :hstore           default(""), not null
#
