class Omniauth::AuthorizationController < ActionController::Base

  before_action :ensure_user_type_present
  before_action :ensure_within_omniauth_flow, only: %i[callback callback_failure]
  before_action :flash_callback_data, only: %i[callback callback_failure]

  def authorize
    redirect_to authorize_url(authorize_params)
  end

  def callback
    redirect_to callback_url
  end

  def callback_failure
    redirect_to callback_failure_url
  end

  private

  def authorize_url(parameters={})
    URI("/auth/#{provider}").tap do |url|
      parameters.merge! authorize_query
      url.query = parameters.permit!.to_query
    end.to_s
  end

  def authorize_query
    { user_type: user_type, origin: request.referer }
  end

  def callback_url
    "/#{user_type}/auth/#{provider}/callback"
  end

  def callback_failure_url
    "/#{user_type}/auth/callback/failure"
  end

  def ensure_user_type_present
    abort_processing if user_type.blank?
  end

  def ensure_within_omniauth_flow
    abort_processing if omniauth_strategy.blank?
  end

  def abort_processing
    redirect_to root_path
  end

  def flash_callback_data
    flash[:omniauth_provider] = provider
    flash[:omniauth_result] = omniauth_result
    flash[:omniauth_origin] = omniauth_origin
    flash[:omniauth_params] = omniauth_params
    flash[:omniauth_error] = omniauth_error
    flash[:omniauth_error_type] = omniauth_error_type
  end

  def authorize_params
    params.except :provider, :origin, :user_type, :controller, :action
  end

  def provider
    omniauth_strategy&.name || params[:provider]
  end

  def omniauth_result
    request.env['omniauth.auth']
  end

  def omniauth_origin
    request.env['omniauth.origin']
  end

  def omniauth_params
    request.env['omniauth.params']
  end

  def omniauth_error
    request.env['omniauth.error']
  end

  def omniauth_error_type
    request.env['omniauth.error.type']
  end

  def user_type
    omniauth_params.try(:[], 'user_type') || params[:user_type]
  end

  def omniauth_strategy
    request.env['omniauth.strategy']
  end

end
