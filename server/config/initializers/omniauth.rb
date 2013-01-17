OmniAuth.config.logger = Rails.logger

api_credentials = YAML.load_file(File.expand_path('../google_api.yml', File.dirname(__FILE__)))


GoogleCredentials = Module.new do
  const_set :CLIENT_ID, api_credentials["CLIENT_ID"]
  const_set :CLIENT_SECRET, api_credentials["CLIENT_SECRET"]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, GoogleCredentials::CLIENT_ID, GoogleCredentials::CLIENT_SECRET, {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar'
  }
end
