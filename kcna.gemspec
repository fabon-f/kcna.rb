lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kcna/version"

Gem::Specification.new do |spec|
  spec.name = "kcna"
  spec.version = KCNA::VERSION
  spec.authors = ["Hinata"]
  spec.email = ["syobon.hinata.public@gmail.com"]
  spec.license = "MIT"

  spec.summary = %q{A Ruby gem for kcna.kp(KCNA, Korean Central News Agency)}
  # spec.description = %q{TODO: Write a longer description or delete this line.}
  spec.homepage = "https://github.com/hinamiyagk/kcna.rb"

  spec.files = Dir["LICENSE", "README.md", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "httpclient", "~> 2.8"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
