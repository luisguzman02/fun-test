Mifiel.config do |config|
  config.app_id = Rails.application.secrets.mifiel_app_id
  config.app_secret = Rails.application.secrets.mifiel_app_secret
  config.base_url = 'https://sandbox.mifiel.com/api/v1' # Rails.application.secrets.mifiel_host
end
