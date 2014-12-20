Post.seed do |p|
  p.id = 1
  p.title = 'Welcome to RigidOJ!'
  p.raw = <<-END.gsub(/^\s+\|/, '')
    |Add or import problem to get started.
  END
  p.user_id = -1
  p.published = true
end

Post.seed do |p|
  p.id = 2
  p.title = 'Help'
  p.raw = <<-END.gsub(/^\s+\|/, '')
    |Helpful information for your user.
    |
    |Edit this post to get started.
  END
  p.user_id = -1
  p.published = false
end

Post.seed do |p|
  p.id = 3
  p.title = 'About'
  p.raw = <<-END.gsub(/^\s+\|/, '')
    |About this site & TOS information.
    |
    |Edit this post to get started.
  END
  p.user_id = -1
  p.published = false
end
