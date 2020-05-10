# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-x/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-x'
  spec.version       = CocoapodsX::VERSION
  spec.authors       = ['panghu']
  spec.email         = ['panghu.lee@gmail.com']
  spec.description   = %q{扩展pod x命令, 实现快速清理缓存, 快速打开Xcode等操作, 使用souce, pods两个dsl实现快速切换pod 'NAME', :path=>'url'开发模式, 对壳工程无入侵.}
  spec.summary       = %q{扩展pod x命令, 实现快速清理缓存, 快速打开Xcode等操作, 使用souce, pods两个dsl实现快速切换pod 'NAME', :path=>'url'开发模式, 对壳工程无入侵.}
  spec.homepage      = 'https://github.com/CocoapodsX/cocoapods-x'
  spec.license       = 'MIT'
  
  spec.files         = Dir["lib/**/*.rb"] + %w{ README.md LICENSE }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
