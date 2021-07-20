class EndpointGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :api_version, type: :string
  argument :endpoint_name, type: :string

  class_option :endpoint, type: :string, default: '/'
  class_option :method, type: :string, default: 'get'
  class_option :endpoint_params, type: :array
  class_option :include_helper_params
  
  def create_api_call
    @api_service = file_name.underscore
    @api_version = api_version
    @endpoint_name = endpoint_name
    @endpoint = options[:endpoint]

    raise ArgumentError, 'Endpoint name required' unless @endpoint_name
    raise ArgumentError, 'Version is required, e.g. V1' unless @api_version
    raise ArgumentError, 'Version should not be included in your endpoint, generator will build it for you' if @endpoint.downcase.include?(@api_version.downcase)

    @endpoint_reference = @api_service.camelize + '::' + @api_version.camelize + '::ApiEndpoints'
    @full_endpoint_reference = @endpoint_reference + '.' + @endpoint_name.underscore

    @endpoint = '/' + @endpoint unless @endpoint.first == '/'
    @endpoint = @api_version.downcase + @endpoint
    @method = options[:method].to_sym

    create_endpoint_params if options[:endpoint_params].present?
    create_helper_params if options[:include_helper_params].present?

    spec_file_name = @endpoint_name.underscore + '_spec.rb';
    spec_dir = 'spec/services/'
    spec_api_dir = spec_dir + @api_service.underscore + '/'
    service_version_dir = spec_api_dir + @api_version.downcase + '/'

    Dir.mkdir spec_dir unless File.exist?(spec_dir)
    Dir.mkdir spec_api_dir unless File.exist?(spec_api_dir)
    Dir.mkdir service_version_dir unless File.exist?(service_version_dir)

    spec_file_path = service_version_dir + spec_file_name

    template 'endpoint_spec.erb', spec_file_path

    service_dir_path = "app/services/#{@api_service}/"
    service_api_version_path = service_dir_path + @api_version + '/'

    template 'api_call.erb', service_api_version_path + "api_calls/#{@endpoint_name.underscore}.rb"

    api_call_file = ERB.new load_template('endpoint_helper.erb')
    
    inject_into_file service_api_version_path + 'endpoint_helpers.rb', after: "  # API Endpoint Helpers\n" do
      api_call_file.result(binding)
    end

    mixin = ERB.new load_template('mixin.erb')

    inject_into_file service_api_version_path + 'api_endpoints.rb', after: "  # API call modules\n" do
      mixin.result(binding)
    end
  end

  private

  def load_template(template_file)
    template_path = File.join(File.dirname(__FILE__), 'templates/' + template_file)
    File.read(template_path)
  end

  def create_helper_params
    @helper_params = @endpoint_params
  end

  def create_endpoint_params
    @endpoint_params = options[:endpoint_params][0..-2].each_with_object('') do |p, str|
      str << p.underscore << ', '
    end
    @endpoint_params << options[:endpoint_params].last
  end
end
