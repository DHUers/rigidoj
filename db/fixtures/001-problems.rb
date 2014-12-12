Problem.seed do |p|
  p.id = 1
  p.user_id = -1
  p.title = 'A + B Problem'
  p.public = true
  p.draft = false
  p.judge_type = :full_text
  p.raw = <<-RAW
    ## Description
    Give you two integers A and B, please output A+B.

    ## Sample Input
    ```
    1 2
    ```

    ## Sample Output
    ```
    3
    ```
  RAW
end
