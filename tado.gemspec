# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tado/version'

Gem::Specification.new do |spec|
  spec.name          = 'tado'
  spec.version       = Tado::VERSION
  spec.authors       = ['Jamie Schembri']
  spec.email         = ['jamie@schembri.me']

  spec.summary       = "Quick 'n dirty API client for Tado's V2 API"
  spec.homepage      = 'https://github.com/shkm/tado'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_development_dependency 'bundler', '~> 1.13'
end
