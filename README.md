### RED API Generators
This simple gem has two generators to support creating a basic API consumer framework for your Rails Applications.

#### Generators
- red-api:service
- red-api:endpoint

#### Usage
```sh
rails generate service ApiName Version --endpoint https://service/endpoint/ --key api_key service_api_key_env_name
rails generate endpoint ServiceName Version EndpointName --endpoint /endpoint/#{param1}/#{param2} --method-params param1 param2 --include-helper-params
```
The service generator will setup the framework which uses Faraday for your http calls and Oj gem for faster json parsing.
The endpoint generator will setup an endpoint with an endpoint helper method for easier testing and adds a spec file.

#### Installation
```ruby
gem 'red-api'
```
#### Dependancies
```ruby
gem 'faraday'
gem 'oj'
gem 'rspec-rails
```

#### Testing
The generator still needs tests and this is my first generator and I'm still learning how to write tests. If you wish to contribute before I get a chance to add tests please PR with tests and I'll review it. Until then the gem won't be published until tests are written.