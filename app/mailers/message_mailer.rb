class MessageMailer < ApplicationMailer

  default from: "Blaufuchs Verlag <shop@blaufuchs-verlag.de>"
  default to: "Blaufuchs Verlag <shop@blaufuchs-verlag.de>"

  def new_message(message)
    @message = message

    mail subject: "Nachricht von #{message.name}"
  end

end
