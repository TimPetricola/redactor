require File.expand_path '../lib/redactor/version', __FILE__

Gem::Specification.new do |s|
  s.authors       = ['Tim Petricola']
  s.email         = ['tim.petricola@gmail.com']
  s.summary       = 'Redact parts of text defined by custom rules (e.g. emails, phone numbers)'
  s.license       = 'MIT'
  s.homepage      = 'https://github.com/TimPetricola/redactor'
  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split "\n"
  s.name          = 'redactor'
  s.require_paths = ['lib']
  s.version       = Redactor::VERSION

  s.add_development_dependency 'rspec', '~> 3.3.0'
  s.add_development_dependency 'rake', '~> 10.4.2'
end
