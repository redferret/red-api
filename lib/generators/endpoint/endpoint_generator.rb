class EndpointGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :endpoint_name, type: :string
  argument :api_version, type: :string
  argument :endpoint, type: :string

  class_option :method, type: :string, default: :get
  class_option :endpoint_params, type: :array
  class_option :helper_params, type: :array
  
  def create_api_call
    @api_service = file_name.underscore
    @api_version = api_version
    @endpoint_name = endpoint_name
    @endpoint = endpoint

    raise ArgumentError 'Endpoint name required' unless @endpoint_name
    raise ArgumentError 'Endpoint is required' unless @endpoint

    @endpoint_reference = @api_service.camelize + '::' + @api_version.camelize + '::ApiEndpoints'
    @full_endpoint_reference = @endpoint_reference + '.' + @endpoint_name.underscore

    @endpoint = @endpoint[1..] unless @endpoint.first == '/'
    @method = options[:method].to_sym unless options[:method]

    create_endpoint_params unless options[:endpoint_params]
    create_helper_params unless options[:helper_params]

    spec_file_name = @endpoint_name.underscore + '_spec.rb';
    spec_dir = 'spec/services/'
    spec_api_dir = spec_dir + @api_service.underscore + '/'
    service_version_dir = spec_api_dir + @api_version + '/'

    Dir.mkdir spec_dir unless File.exist?(spec_dir)
    Dir.mkdir spec_api_dir unless File.exist?(spec_api_dir)
    Dir.mkdir service_version_dir unless File.exist?(service_version_dir)

    spec_file_path = service_version_dir + spec_file_name

    unless File.exist? spec_file_path
      template 'endpoint_spec.erb', spec_file_path
    else
      end_point_test = ERB.new load_template('endpoint_test.erb')
      inject_into_file spec_file_path, after: "  # API Endpoint tests\n" do
        end_point_test.result(binding)
      end
    end

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
    @endpoint_params = options[:helper_params][0..-2].each_with_object('') do |p, str|
      str << p << ', '
    end
    @endpoint_params << options[:helper_params].last
  end

  def create_endpoint_params
    @endpoint_params = options[:endpoint_params][0..-2].each_with_object('') do |p, str|
      str << p << ', '
    end
    @endpoint_params << options[:endpoint_params].last
  end
end
