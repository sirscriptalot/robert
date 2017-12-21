require_relative './lib/robert'

Gem::Specification.new do |s|
  s.name     = 'robert'
  s.summary  = 'Robert'
  s.version  = Robert::VERSION
  s.authors  = ['Steve Weiss']
  s.email    = ['weissst@mail.gvsu.edu']
  s.homepage = 'https://github.com/sirscriptalot/robert'
  s.license  = 'MIT'
  s.files    = `git ls-files`.split("\n")

  s.add_development_dependency 'cutest', '~> 1.2'
end
