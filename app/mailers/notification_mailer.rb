class NotificationMailer < ApplicationMailer

  # helper :application

  def new_order(order)
    @order = order
    mail(
      to: order.email,
      subject: "Vielen Dank für Ihren Einkauf bei Blaufuchs",
      :from => 'shop@blaufuchs-verlag.de',
      :track_opens => 'true'
    )
  end

  def shipped(order)
    @order = order
    mail(
      to: order.email,
      subject: "Ihre Bestellung bei Blaufuchs wurde versandt",
      :from => 'shop@blaufuchs-verlag.de',
      :track_opens => 'true'
    )
  end

  def stop(order)
    @order = order
    mail(
      to: "admin@blaufuchs-verlag.de",
      subject: "Eine Bestellung wurde gestoppt."
    )
  end

end
