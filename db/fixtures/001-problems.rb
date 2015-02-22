input = Tempfile.new(['input', '.in'])
output = Tempfile.new(['output', '.out'])
input.write <<END.gsub(/^\s*\|/, '')
|1 2
|4 6
|-1 1
|5 0
|0 0
|2147483646 1
END
output.write <<-END.gsub(/^\s*\|/, '')
|3
|10
|0
|5
|0
|2147483647
|
END
input.rewind
output.rewind

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
    |
    |    1 2
    |
    |## Sample Output
    |
    |    3
  END
  p.input_file = input
  p.output_file = output
end

input.close
input.unlink
output.close
output.unlink
