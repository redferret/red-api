class EndpointGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :endpoint_name, type: :string
  argument :endpoint, type: :string
  class_option :method, type: :string, default: :get
  class_option :method_params, type: :array

  def create_api_call
    @api_name = endpoint_name
    @endpoint = endpoint
    @endpoint = @endpoint[1..] if @endpoint.first == '/'
    @method = options[:method].to_sym

    if options[:method_params].present?
      @method_params = options[:method_params][0..-2].each_with_object('') do |p, str|
        str << p << ', '
      end
      @method_params << options[:method_params].last
    end

    @api_service = file_name.underscore
    service_dir_path = "app/services/#{@api_service}/"

    template 'api_call.erb', service_dir_path + "api_calls/#{@api_name.underscore}.rb"

    temp = ERB.new <<-'EOF'

  def <%= @api_name.underscore%>_endpoint<%="(#{@method_params})" if @method_params.present?%>
    <%= "\"#{@endpoint}\".freeze" if @endpoint.present? %>
  end
    EOF
    
    inject_into_file service_dir_path + 'endpoint_helpers.rb', after: "  # API Endpoint Helpers\n" do
      temp.result(binding)
    end

    temp = ERB.new <<-'EOF'
  extend <%= @api_name.camelize%>
    EOF

    inject_into_file service_dir_path + 'api_endpoints.rb', after: "  # API call modules\n" do
      temp.result(binding)
    end
  end
end
