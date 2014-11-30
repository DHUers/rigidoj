Post.seed do |p|
  p.id = 1
  p.title = 'Welcome to RigidOJ!'
  p.raw = <<END
Add or import problem to get started.
END
  p.author_id = -1
  p.published = true
end
