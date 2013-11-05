# Load the rails application
require File.expand_path('../application', __FILE__)

# Load API keys
API = {}
Dir.glob("config/apis/*").each do |dir|
  API.merge!(YAML.load_file(dir))
end

# Initialize the rails application
ProjectName::Application.initialize!
