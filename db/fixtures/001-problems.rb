Problem.seed do |p|
  p.id = 1
  p.title = 'A + B Problem'
  p.public = true
  p.judge_type = :full_text
  p.raw = <<-END.gsub(/^\s+\|/, '')
    |## Description
    |Give you two integers A and B, please output A+B.
    |
    |## Sample Input
    |```
    |1 2
    |```
    |
    |## Sample Output
    |```
    |3
    |```
  END
  p.input_file = 'a'
  p.output_file = 'b'
end
