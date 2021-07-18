class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :api_endpoint, type: :string
  class_option :key, type: :array

  def create_api_service
    @api_name = file_name
    @api_endpoint = api_endpoint
    @env_var_opts = options[:key]
    raise 'Need to define the name of your API service with --api' unless @api_name.present?

    @api_dir_name = @api_name.underscore

    service_dir_path = "app/services/#{@api_dir_name}/"

    Dir.mkdir service_dir_path unless File.exist?(service_dir_path)
    Dir.mkdir "#{service_dir_path}/api_calls" unless File.exist?("#{service_dir_path}/api_calls")

    template 'api_endpoints.erb', service_dir_path + 'api_endpoints.rb'
    template 'client.erb', service_dir_path + 'client.rb'
    template 'endpoint_helpers.erb', service_dir_path + 'endpoint_helpers.rb'
  end
end
