Post.seed do |p|
  p.id = 1
  p.title = 'Welcome to RigidOJ!'
  p.pinned = true
end

Post.seed do |p|
  p.id = 2
  p.title = 'Help'
end

Post.seed do |p|
  p.id = 3
  p.title = 'About'
end

Comment.seed do |s|
  s.id = 1
  s.user_id = Rigidoj::SYSTEM_USER_ID
  s.post_id = 1
  s.comment_number = 1
  s.raw = <<END
Add or import problem to get started.
END
end

Comment.seed do |s|
  s.id = 2
  s.user_id = Rigidoj::SYSTEM_USER_ID
  s.post_id = 2
  s.comment_number = 1
  s.raw = <<END
Helpful information for your user.

Edit this post to get started.
END
end

Comment.seed do |s|
  s.id = 3
  s.user_id = Rigidoj::SYSTEM_USER_ID
  s.post_id = 3
  s.comment_number = 1
  s.raw = <<END
About this site & TOS information.

Edit this post to get started.
END
end
