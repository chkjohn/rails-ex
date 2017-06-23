module ActionDispatch::Routing
  class Mapper
    def omniauth_routes_for(user_type, providers)
      unless @_omniauth_base_routes_set

        match '/:user_type/auth/:provider',
          to: 'omniauth/authorization#authorize',
          as: 'omniauth_authorize',
          via: %i[get post]

        match '/auth/:provider/callback',
          to: 'omniauth/authorization#callback',
          as: 'omniauth_callback',
          via: %i[get]

        match '/auth/callback/failure',
          to: 'omniauth/authorization#callback_failure',
          as: 'omniauth_callback_failure',
          via: %i[get]

      end
      @_omniauth_base_routes_set = true

      user_type_pluralized = user_type.to_s.pluralize
      providers_matcher_string = providers.collect { |x| Regexp.quote(x) }.join('|')

      match "/#{user_type}/auth/:action/callback",
        controller: "#{user_type_pluralized}/omniauth_callbacks",
        via: %i[get],
        constraints: { action: Regexp.new(providers_matcher_string) }

      match "/#{user_type}/auth/callback/failure",
        to: "#{user_type_pluralized}/omniauth_callbacks#failure",
        via: %i[get]
    end
  end
end
