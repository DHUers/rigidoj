Fabricator(:problem) do
  title {sequence(:title) {|i| "title#{i}"}}
  raw 'problem'
  judge_type :full_text
  before_create do |p|
    p.input_file = File.open(File.join(Rails.root, 'spec', 'fixtures', 'local_problem', 'dummy_input.in'))
    p.output_file = File.open(File.join(Rails.root, 'spec', 'fixtures', 'local_problem', 'dummy_output.out'))
  end
end
