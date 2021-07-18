Gem::Specification.new do |spec|
  spec.name        = "red-api"
  spec.version     = '0.1.1'
  spec.authors     = ["Richard DeSilvey"]
  spec.email       = ["rdesilvey@gmail.com"]
  spec.homepage    = "https://github.com/redferret/red-api"
  spec.summary     = "API service and endpoint generators for Rails"
  spec.description = "Generate API service and endpoints for API consumption"
  spec.license     = "MIT"

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "ruby", "~> 2.7.2"

  spec.add_development_dependency "oj", '~> 3.12.1'
  spec.add_development_dependency "faraday", '~> 1.5.1'
end