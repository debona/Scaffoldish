Gem::Specification.new do |s|
  s.name        = 'scaffold-ish'
  s.summary     = 'Universal scaffolder super powa for everyone!'
  s.description = "Brings Rails-ish scaffolding super powa for every developpers, no matter they don't code with blessed RoR."
  s.authors     = ['Thomas DE BONA']
  s.email       = 'thomas.debona@gmail.com'

  s.version     = '0.0.0'
  s.date        = '2014-11-21'

  s.files       = Dir['{lib}/**/*.rb', 'bin/*', '*.md']
  s.executables = Dir['bin/*'].collect { |executable| File.basename(executable) }

  s.homepage    = 'http://rubygems.org/gems/scaffold-ish'
  s.license     = 'MIT'
end
