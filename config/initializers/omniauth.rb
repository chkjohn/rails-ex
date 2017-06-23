Rails.application.config.middleware.use OmniAuth::Builder do

  # refer to https://github.com/plataformatec/devise/wiki/OmniAuth-with-multiple-models

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.
  # provider :github, 'APP_ID', 'APP_SECRET', :scope => 'user,public_repo';

  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']

  on_failure { |env| Omniauth::AuthorizationController.action(:callback_failure).call(env) }

end
