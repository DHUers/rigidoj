require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def publish_to_proxy_queue(solution)
  proxy_queue = Rigidoj::judger_proxy_queue
  s = BasicSolutionSerializer.new(solution, root: 'solution')
  puts s.to_json
  proxy_queue.publish s.to_json
end

frog = Problem.seed do |p|
  p.id = Problem.maximum(:id) + 1
  p.title = 'Frog'
  p.raw = "Once upon a time, there is a little frog called Matt. One day, he came to a river.

The river could be considered as an axis.Matt is standing on the left bank now (at position 0). He wants to cross the river, reach the right bank (at position M). But Matt could only jump for at most L units, for example from 0 to L.

As the God of Nature, you must save this poor frog.There are N rocks lying in the river initially. The size of the rock is negligible. So it can be indicated by a point in the axis. Matt can jump to or from a rock as well as the bank.

You don't want to make the things that easy. So you will put some new rocks into the river such that Matt could jump over the river in maximal steps.And you don't care the number of rocks you add since you are the God.

Note that Matt is so clever that he always choose the optimal way after you put down all the rocks."
  p.source = 'HDU 5037'
  p.public = true
  p.judge_type = :remote_proxy
  p.remote_proxy_vendor = 'HDU,5037'
end

Problem.seed do |p|
  p.id = Problem.maximum(:id) + 1
  p.title = 'Joe is learning to speak'
  p.raw = "Joe is a 4-year-old child learning to speak his mother tongue. He tried to memorize every possible
sentence in the language but he soon realized that the number of different sentences is unbounded.
He decided to concentrate on memorizing the subsequences of size up to n and their meaning. Joe
understands a sentence if he has previously memorized all its subsequences of size ≤ n.
Every afternoon, Joe starts reading sentences one by one. He remembers everything he has learned
in the previous days. After reading a sentence, he asks for every word he doesn’t know and learns it.
If he can’t fully understand the sentence he asks for the meaning of the whole sequence. After this, he
memorizes every subsequence of size up to n and reads the next sentence.
For example: supose that Joe memorizes only subsequences of 1 or 2 words and he already knows
the sentences “I live in a house” and “This is a green house”. He will fully understand the sentence
“I live in a green house”, since he already knows all the subsequences of size 1 and 2. However, if
he decided to memorize subsequences up to size 3, he will ask for the meaning of the whole sentence
because “in a green” is not a subsequence of size 3 in any previous sentence.
Obviously, Joe always knows his name."
  p.source = 'UVa 12682'
  p.public = true
  p.judge_type = :remote_proxy
  p.remote_proxy_vendor = 'UVa,12682'
end

frog_solution = Solution.seed do |s|
  s.id = Solution.maximum(:id) + 1
  s.user_id = -1
  s.problem_id = frog.first.id
  s.platform = 'c'
  s.source = "fake"
end

publish_to_proxy_queue(frog_solution[0])
