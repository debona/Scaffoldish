Gem::Specification.new do |s|
  s.name        = 'scaffoldish'
  s.summary     = 'Universal scaffolding super powa for everyone!'
  s.description = "Brings Rails-ish scaffolding super powa for every developpers, no matter they don't code with blessed RoR."

  s.authors     = ['Thomas DE BONA']
  s.email       = 'thomas.debona@gmail.com'

  s.version     = '0.0.1'
  s.date        = Date.today.to_s

  s.files       = Dir['{lib}/**/*.rb', 'bin/*', '*.md']
  s.executables = Dir['bin/*'].collect { |executable| File.basename(executable) }

  s.homepage    = 'http://github.com/debona/Scaffoldish'
  s.license     = 'MIT'
end
