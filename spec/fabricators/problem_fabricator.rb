Fabricator(:problem) do
  title {sequence(:title) {|i| "title#{i}"}}
  raw 'problem'
  judge_type :full_text
  before_create do |p|
    File.open(File.join(Rails.root, 'spec', 'fixtures', 'local_problem', 'dummy_input.txt')) { |f| p.input_file = f }
    File.open(File.join(Rails.root, 'spec', 'fixtures', 'local_problem', 'dummy_output.txt'))  { |f| p.output_file = f }
  end
end
