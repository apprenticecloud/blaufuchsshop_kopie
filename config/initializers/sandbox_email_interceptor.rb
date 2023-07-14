require "#{Rails.root}/app/mailers/sandbox_email_interceptor.rb" if Rails.env.development?
ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
