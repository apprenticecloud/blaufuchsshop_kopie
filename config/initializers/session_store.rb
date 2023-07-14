if Rails.env.development?
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_testapp_session'
