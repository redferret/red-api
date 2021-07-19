class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :version, type: :string
  argument :api_endpoint, type: :string
  class_option :key, type: :array

  def create_api_service
    @api_name = file_name
    @api_version = version
    @api_endpoint = api_endpoint
    @env_var_opts = options[:key]

    raise ArgumentError, 'Need to give the API version' unless @api_version.present?
    raise ArgumentError, 'Need to give the API endpoint URI e.g. https://api/' unless @api_endpoint.present?

    @full_api_reference = @api_name.camelize + '::' + @api_version.upcase
    @api_endpoint = @api_endpoint << '/' unless @api_endpoint.last == '/'

    root_dir = "app/services/"
    Dir.mkdir root_dir unless File.exist?(root_dir)

    api_version_path = root_dir + @api_version.downcase + '/'

    Dir.mkdir api_version_path unless File.exist?(api_version_path)

    service_dir_path = api_version_path + api_name.underscore + '/'

    Dir.mkdir service_dir_path unless File.exist?(service_dir_path)
    Dir.mkdir "#{service_dir_path}/api_calls" unless File.exist?("#{service_dir_path}/api_calls")

    template 'api_endpoints.erb', service_dir_path + 'api_endpoints.rb'
    template 'client.erb', service_dir_path + 'client.rb'
    template 'endpoint_helpers.erb', service_dir_path + 'endpoint_helpers.rb'
  end
end
