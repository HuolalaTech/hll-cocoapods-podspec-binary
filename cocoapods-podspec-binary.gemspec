# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cocoapods-podspec-binary/gem_version.rb"

Gem::Specification.new do |spec|
  spec.name = "cocoapods-podspec-binary"
  spec.version = CocoapodsPodspecBinary::VERSION
  spec.authors = ["pengpeng.dai"]
  spec.email = ["pengpeng.dai@huolala.cn"]
  spec.description = %q{A short description of cocoapods-podspec-binary.}
  spec.summary = %q{A longer description of cocoapods-podspec-binary.}
  spec.homepage = "https://github.com/EXAMPLE/cocoapods-podspec-binary"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*"]
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
