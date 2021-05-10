# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'pronto/eslint_npm/version'

Gem::Specification.new do |s|
  s.name     = 'pronto-eslint_npm'
  s.version  = Pronto::ESLintNpmVersion::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors  = ['Markus Doits', 'Mindaugas Mozūras']
  s.email    = 'markus.doits@gmail.com'
  s.homepage = 'https://github.com/doits/pronto-eslint_npm'
  s.summary  = <<-EOF
    Pronto runner for ESLint, pluggable linting utility for JavaScript and JSX
  EOF

  s.licenses              = ['MIT']
  s.required_ruby_version = '>= 2.3.0'

  s.files            = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(lib/|(LICENSE|README.md)$)}) }
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths    = ['lib']
  s.requirements << 'eslint (in PATH)'

  s.add_dependency('pronto', '~> 0.11.0')
  s.add_development_dependency('rake', '>= 11.0', '< 13')
  s.add_development_dependency('rspec', '~> 3.4')
end
