Problem.seed do |p|
  p.id = 1
  p.author_id = -1
  p.title = 'A + B Problem'
  p.raw = <<RAW
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
