OmniAuth.config.logger = Rails.logger

api_credentials = YAML.load_file(File.expand_path('../google_api.yml', File.dirname(__FILE__)))
CLIENT_ID = api_credentials["CLIENT_ID"]
CLIENT_SECRET = api_credentials["CLIENT_SECRET"]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, CLIENT_ID, CLIENT_SECRET, {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar'
  }
end
