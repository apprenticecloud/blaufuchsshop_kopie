class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['bs@websites-smart.de']
    message.bcc = []
  end
end