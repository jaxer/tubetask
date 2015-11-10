Apipie.configure do |config|
  config.app_name = "Tubetask"
  config.api_base_url = ""
  config.doc_base_url = "/docs"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.app_info = "REST application sample."
  config.copyright = "&copy; 2015.11 Alex"
  config.validate = false
  config.validate_value = false
end
