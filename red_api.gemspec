Gem::Specification.new do |spec|
  spec.name        = "red-api"
  spec.version     = 0.1.0
  spec.authors     = ["Richard DeSilvey"]
  spec.email       = ["rdesilvey@gmail.com"]
  spec.homepage    = "https://github.com/redferret/red-api"
  spec.summary     = "API service and endpoint generators for Rails"
  spec.description = "Generate API service and endpoints for API consumption"
  spec.license     = "MIT"

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "rails", "~> 5.2.5", ">= 6.0.2.1"

  spec.add_development_dependency "oj"
  spec.add_development_dependency "faraday"
end