# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenkins_cron/version'

Gem::Specification.new do |spec|
  spec.name          = "jenkins_cron"
  spec.version       = JenkinsCron::VERSION
  spec.authors       = ["Ryosuke IWANAGA"]
  spec.email         = ["riywo.jp@gmail.com"]
  spec.description   = %q{A DSL for Jenkins cron job}
  spec.summary       = %q{Simple DSL to define Jenkins scheduled jobs}
  spec.homepage      = "https://github.com/riywo/jenkins_cron"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "jenkins_api_client", "~> 0.13.0"
  spec.add_dependency "activesupport"
  spec.add_dependency "chronic"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
